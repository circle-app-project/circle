# Circle — Codebase Audit & Architecture Review

**Date:** 2026-06-24
**Reviewed at branch:** `code-audit`
**App version:** `0.1.5+12`
**Flutter:** 3.44.3 (stable) · Dart SDK constraint `^3.7.0-183.0.dev`
**Scope:** ~22,100 lines of hand-written Dart across 6 product features (`auth`, `meds`, `water`, `home`, `emergency`, `profile`) plus `health_connect`.

---

## 1. Executive Summary

Circle is a Flutter + Firebase + ObjectBox app for Sickle Cell disease management. The codebase shows a **strong, deliberate architectural intent** — a clean feature-first layout, a layered `Screen → Notifier → Repository → Service` flow, functional error handling with `Either`, and consistent documentation. Whoever set this up understood the patterns they were reaching for.

However, the **execution diverges from the intent** in ways that matter. The dependency-injection story is undermined by global mutable singletons that defeat the very testability the layering was designed to enable; there is **effectively no automated test coverage** (a single 30-line stub) for an app that stores and processes health data; there is a large volume of dead/commented code and TODOs; and a few real correctness bugs exist in core model logic. For a health-domain application, the privacy posture (verbose logging of state, always-on Crashlytics, no Firestore security rules in the repo) needs attention before this is production-grade.

### Overall Rating: **5.5 / 10** — "Promising architecture, gaps in execution and rigor"

| Dimension | Score | One-line verdict |
|---|---|---|
| Architecture & layering | 7.0 | Sound, idiomatic structure; let down by DI execution |
| State management (Riverpod) | 5.0 | Works, but anti-patterns negate Riverpod's strengths |
| Error handling | 7.0 | Genuine strength; one broken mapper |
| Code quality & consistency | 5.0 | Heavy boilerplate, dead code, a few real bugs |
| Testing | 1.0 | Essentially absent — the biggest risk |
| Tooling & CI/CD | 6.5 | Good release automation; no test gate |
| Security & privacy | 4.0 | Health data + verbose logs + no rules in repo |
| Dependencies | 7.0 | Current and reasonable; a few pre-1.0 bets |
| Documentation | 7.0 | Strong inline docs and CLAUDE.md |

The numbers are weighted toward the dimensions that matter most for a shipping health app (testing, state management, security). A codebase with this architecture and *real* tests would comfortably sit at 7.5–8.

---

## 2. What's Good

These are real strengths worth preserving through any refactor.

### 2.1 Clean feature-first structure
The `lib/features/<name>/{models,services,repositories,providers,screens}` convention is applied consistently across every feature. A new engineer can open any feature and immediately know where things live. The barrel files (`auth.dart`, `meds.dart`, etc.) keep imports tidy. `core/` and `components/` separation is correct.

### 2.2 Disciplined layering and separation of concerns
The `Screen → Notifier → Repository → Service` flow is followed almost everywhere:
- **Services** do raw I/O only (ObjectBox boxes, Firebase calls) and throw typed `AppException`s.
- **Repositories** wrap services, orchestrate local/remote, and convert exceptions into `Failure` via `futureHandler`.
- **Notifiers** hold `AsyncValue` state and expose intent-level methods to the UI.

This is the right shape. The local-first design (ObjectBox as source of truth, Firebase as remote sync via `updateRemote`/`getFromRemote` flags) is a sensible choice for an app that must work offline.

### 2.3 Functional error handling
`core/utils/method_handler.dart` (`futureHandler`/`methodHandler`) is the best-engineered part of the codebase. It centralizes try/catch, maps `FirebaseException` and `AppException` to typed `Failure`s, logs, and reports to Crashlytics — all in one place. Combined with `FutureEither<T> = Future<Either<Failure, T>>` (fpdart), repositories stay clean and exceptions don't leak uncontrolled into the UI. This is a genuine asset.

### 2.4 Error reporting & crash handling
`CrashlyticsService` correctly wires `FlutterError.onError` and `PlatformDispatcher.instance.onError`, and distinguishes fatal vs non-fatal. The plumbing through `futureHandler` means most caught errors are reported with context.

### 2.5 Documentation culture
Models and key utilities carry thorough dartdoc with usage examples (`Medication`, `AuthRepository`, `futureHandler`). `CLAUDE.md` accurately describes the architecture. This is well above average for an app of this size.

### 2.6 Release automation
The CI/CD (`.github/workflows/deploy.yml`) auto-increments the build number, tags, builds AAB/APK, and deploys to the Play internal track on `release/*` PRs. The "merge-not-rebase / don't touch the build number" conventions are documented. That's mature for a solo/small-team project.

### 2.7 Theming discipline
A centralized Material 3 theme (`AppColors`, `AppTextStyles`, `AppConstants`) with a custom font and spring-based theme animation. The intent to avoid hardcoded colors/spacing is stated and largely followed.

---

## 3. What Needs Improvement

Ordered roughly by severity.

### 3.1 🔴 Critical — Almost no test coverage
- `test/` contains **one file** (`widget_test.dart`, 30 lines) — the default Flutter counter stub, which doesn't even match this app.
- There are **zero** unit tests for repositories, notifiers, models, the `futureHandler` error mapper, or the ObjectBox type converters.
- `mocktail` is in `dev_dependencies` and the architecture was explicitly built for injectable mocks — but the capability is unused.

**Why it matters:** This is a health app. Medication scheduling, dose tracking, streak calculation, and date-window queries are exactly the kind of logic that breaks silently. Without tests, every refactor (including the Riverpod 3 upgrade you're considering) is high-risk. This single gap is the largest drag on the score.

### 3.2 🔴 High — Dependency injection is defeated by global singletons
Every notifier file declares **module-level mutable globals** for its service/repository graph and a hand-built provider instance, e.g. in `med_notifier.dart`:

```dart
final MedService medService = MedService();
final MedLocalService medLocalService = MedLocalService(store: database.store);
final MedRepository medRepository = MedRepositoryImpl(...);
final MedNotifierProvider medNotifierProviderImpl =
    MedNotifierProvider(medRepository: medRepository);
```

The notifier then takes the repository as a `build({required MedRepository medRepository})` family parameter, and the UI watches the **pre-constructed global** `medNotifierProviderImpl`. This pattern appears in `auth`, `user`, `meds`, and both `water` notifiers.

Problems:
- **It negates Riverpod's core value.** Provider overrides (`ProviderScope(overrides: ...)`) — the standard way to inject mocks in tests/previews — can't cleanly replace a graph that's already wired through top-level `final`s reading the global `database.store`.
- **`database.store` is touched at file load time** (`MedLocalService(store: database.store)`), creating a hidden initialization-order dependency on `main()` having run. This makes the notifiers essentially un-testable in isolation and fragile to import ordering.
- **The family parameter is misused as a DI seam** when it should be a normal Riverpod dependency (`ref.watch(repositoryProvider)`). Passing a repository as a family key also means Riverpod uses it in equality/caching, which is not the intent.

**Fix direction:** introduce provider-based DI — `@riverpod MedRepository medRepository(ref) => ...` — and have notifiers read `ref.watch(medRepositoryProvider)` instead of a build parameter. Then tests/previews override the repository provider. This also removes the global singletons entirely. (This pairs naturally with the Riverpod 3 migration — see the companion plan.)

### 3.3 🟠 Medium — Repetitive notifier boilerplate; no `AsyncValue.guard`
Every notifier method follows the same 20-line shape: `state = const AsyncValue.loading();` → `await repo.x()` → `response.fold((failure) { state = AsyncValue.error(...); log(...) }, (data) { state = AsyncValue.data(...); log(...) })`. There are ~25 near-identical blocks.

- `AsyncValue.guard` (and the `Either` already in hand) could collapse most of this.
- Several methods set `AsyncValue.loading()` and then call another method that *also* sets loading and re-fetches (e.g. `putMedication` → `getMedications`), producing double loading transitions and an extra round trip.
- `state = AsyncValue.error(failure, failure.stackTrace!)` **force-unwraps** a nullable `StackTrace`. If any `Failure` is constructed without a stack trace, this throws inside the error handler. (`auth_notifier` already hedges with `?? StackTrace.current` in some methods but not others — inconsistent.)

### 3.4 🟠 Medium — Real correctness bugs in core logic

**`Medication.putActivityRecord` double-adds (`models/medication.dart`):**
```dart
if (activityExists) {
  activityRecord.removeAt(index);
  activityRecord.insert(index, newActivity);
} else {
  activityRecord.add(newActivity);
}
activityRecord.add(newActivity);   // <-- always runs, duplicates the record
```
In both branches the record is added an extra time. Adherence/streak data derived from `activityRecord` will be wrong (duplicate entries per day).

**`Failure.fromApi` assumes HTTP status codes (`error/failure.dart`):** it branches on `code.toString().startsWith('4'/'5'/...)`. But the codes flowing in are Firebase/ObjectBox codes (often non-numeric strings or null), not HTTP statuses. The mapping is effectively dead/incorrect for this app's actual error sources, and the method is marked `Todo: Properly implement`.

**`getMedicationScheduledDoses` with `from == null && until != null`** calls `scheduleDosesList.first.date` without a guard — throws on an empty box.

### 3.5 🟠 Medium — Privacy & security posture for a health app
- **Verbose state logging:** there are ~25 `log("Success ${state.value}")` calls plus 181 `log(...)` calls total. `state.value` for these notifiers is the full `AppUser`, medication list, water logs, etc. On Android these go to logcat in release unless stripped — i.e. **health/PII potentially written to device logs**. Logging should be gated behind `kDebugMode` and never dump full domain objects.
- **No Firestore security rules in the repo.** `firebase.json` configures only Flutter platform outputs; there is no `firestore.rules`/`firestore.indexes.json` and no Firestore deploy target. Rules may exist only in the console (unversioned, unreviewable) or may be permissive. For an app writing user health records this is a notable gap.
- **Crashlytics is always-on.** `CrashlyticsService.initialize()` enables collection unconditionally; the opt-in toggle is a `Todo`. Crash reports can contain PII; a health app generally needs consent.
- `google-services.json` and `GoogleService-Info.plist` are committed. This is *technically* acceptable (they're client config, not secrets) but should be a conscious decision; the GCP **service-account key and keystore** are correctly kept out of the repo and injected via CI.

### 3.6 🟡 Low–Medium — Dead code, TODOs, and churn
- **~1,946 commented lines** and **71 TODO/FIXME** markers in hand-written Dart. `main.dart` carries a large commented-out `MaterialApp` block; `med_local_service.clearMedications` has a commented-out query block; notifiers carry long TODO checklists.
- This obscures the real code, inflates diffs, and makes it hard to tell intended behavior from abandoned experiments. Most of it belongs in git history, not the working tree.

### 3.7 🟡 Low — Naming, typos, and small inconsistencies
- Filenames `lib/databse_service.dart` and `lib/crashytics_service.dart` are misspelled (the typo is even acknowledged in `CLAUDE.md`). These are referenced widely, so renaming is a small mechanical change worth doing.
- `authNotifierProviderIml` / `waterLogNotifierProviderIml` ("Iml") vs `…Impl` elsewhere — inconsistent.
- `med_notifier.dart` has an unused `forceRefresh` parameter on several methods that actually drives `updateRemote`, and `MedRepositoryImpl.updateMedication` is a public method not on the interface (dead/duplicated path with `putMedication`).
- `AuthNotifier.authStateChanges()` subscribes to a stream inside a method and returns the stream, but nothing disposes the subscription — a latent leak; this belongs in `build` with a `ref.onDispose`.

### 3.8 🟡 Low — Lint configuration is minimal
`analysis_options.yaml` only layers a few `prefer_const_*` rules on top of `flutter_lints`. For a codebase with these issues, stricter lints would catch a lot automatically. `custom_lint` + `riverpod_lint` are installed but there's no `custom_lint` invocation in CI. Consider `flutter_lints` → a stricter base (or `very_good_analysis`), enabling `avoid_print`, `unawaited_futures`, `prefer_final_locals`, and wiring `dart run custom_lint` into CI.

### 3.9 🟡 Low — A few architectural rough edges
- **`water` is split into three notifiers** (`water_log`, `water_prefs`) plus a derived `Provider<WaterStats>`. The derived stats provider recomputes 5+ date-window filters on every water-log change — fine at current scale, but it's the only feature using a derived provider, so the pattern is inconsistent with the rest of the app (which would have put this in the notifier or repository).
- **`Medication` mixes `Equatable` with mutable ObjectBox fields** (`// ignore: must_be_immutable`) and JSON-string `@Transient` converters for `Dose`/`Frequency`/`Streak`. Storing structured sub-objects as `jsonEncode`d strings means you can't query them and converters can throw on malformed data. Workable, but consider ObjectBox relations or flattened fields for anything you'll query.
- **No route guards.** `LoadingScreen` is the `initial: true` route and presumably branches on auth imperatively; AutoRoute `AuthGuard`s would make the auth/unauth boundary explicit and testable.

---

## 4. Dependencies Review

The dependency set is modern, well-chosen, and current (Flutter 3.44, Firebase BoM-aligned plugins, ObjectBox 4.2, AutoRoute 9, Riverpod 2.6). Notes:

| Package | Assessment |
|---|---|
| `flutter_riverpod` / `riverpod_annotation` 2.6 | Current 2.x. Riverpod 3 is the considered upgrade — see companion plan. |
| `fpdart` 1.1 | Good fit for the `Either` strategy. Stable. |
| `objectbox` 4.2 | Solid local-first choice; pairs well with offline-first design. |
| `auto_route` 9.3 | Fine. Route guards underused. |
| `health` 12.0 | Recently added (Health Connect feature). Verify platform permission handling. |
| `springster` 0.4, `generic_selector` 0.1.0, `hugeicons` 0.0.7 | **Pre-1.0 / niche.** Low-maintenance risk: small/young packages can stall. `generic_selector` and `hugeicons` are easily replaceable; worth tracking. |
| `mesh_gradient`, `flutter_animate`, `percent_indicator`, `fl_chart` | Reasonable UI deps. |
| Icon libraries: `fluentui_system_icons` **and** `hugeicons` **and** `cupertino_icons` | Three icon sets is more than needed; consolidating would cut app size and decision overhead. |

`dev_dependencies` are appropriate (`mocktail`, `riverpod_lint`, `custom_lint`, generators). The gap is not the tooling — it's that the testing tooling is unused and `custom_lint` isn't enforced.

`flutter analyze` is **clean** (only 2 `info`-level deprecation notices for `Radio.groupValue`/`onChanged` in `app_radio.dart` — a quick Material 3 `RadioGroup` migration).

---

## 5. CI/CD Review

**Strengths:** PR builds run `flutter analyze` + debug APK; release PRs auto-version, tag, build AAB, and deploy to Play internal. Secrets are injected, not committed.

**Gaps:**
- **No test step** in CI (because there are no tests). Once tests exist, add `flutter test` as a required gate.
- `deploy.yml` triggers on `pull_request` to `main` (with a `startsWith(head_ref, 'release')` guard), so deployment happens on the **PR**, not on **merge**. That means an unmerged release PR can ship to the internal track. Consider triggering deploy on `push`/merge to `main` or on tag creation instead.
- `custom_lint`/`riverpod_lint` are not run in CI despite being installed.
- iOS build is commented out; only Android is verified by CI.

---

## 6. Prioritized Recommendations

**Now (correctness & safety):**
1. Fix `Medication.putActivityRecord` double-add and the empty-box guard in `getMedicationScheduledDoses`. (3.4)
2. Gate all `log(...)` of domain state behind `kDebugMode` and stop logging full `state.value`. (3.5)
3. Add `firestore.rules` to the repo, lock them down to per-user access, and add a Firestore deploy target. (3.5)
4. Make Crashlytics opt-in (consent) before wider release. (3.5)

**Next (foundations):**
5. Stand up a real test suite — start with `futureHandler`, model serialization/converters, `Medication`/streak logic, then notifier tests with overridden repository providers. Add `flutter test` to CI. (3.1)
6. Replace global service/repository singletons with provider-based DI; drop the `build({required repository})` family seam. (3.2) — do this **with** or **just before** the Riverpod 3 migration.
7. Introduce a shared notifier helper (or `AsyncValue.guard`) to kill the repeated loading/fold boilerplate and the `stackTrace!` force-unwrap. (3.3)

**Then (hygiene):**
8. Delete commented-out code and burn down TODOs (or move to issues). (3.6)
9. Rename `databse_service.dart` / `crashytics_service.dart`; fix `Iml`→`Impl`. (3.7)
10. Tighten lints and run `custom_lint` in CI; fix the `Radio` deprecations. (3.8, §4)
11. Reconsider `Failure.fromApi` to map the error sources you actually have (Firebase/ObjectBox), not HTTP codes. (3.4)
12. Consolidate icon libraries; track the pre-1.0 dependencies. (§4)

---

## 7. On the Riverpod 3.0 Upgrade

You asked specifically about effort. Short version: **the migration surface is small and the effort is moderate (~2–4 focused days), but the risk is elevated specifically because there are no tests to catch regressions.**

The good news is the hard part of most Riverpod 3 migrations — porting legacy `StateProvider`/`StateNotifierProvider`/`ChangeNotifierProvider` — **does not apply here**: this app uses only code-generated `@Riverpod` notifiers (8 of them) plus a single functional `Provider`. The painful surface is the global-singleton DI pattern (§3.2), which you should fix anyway and which the migration is a natural moment to address.

A full effort estimate, breaking-change inventory, and step-by-step plan are in **[`docs/riverpod_3_migration_plan.md`](./riverpod_3_migration_plan.md)**.

---

## 8. Conclusion

Circle is built on a thoughtful skeleton: the layering, error model, and feature structure reflect real architectural judgment, and the documentation is unusually good. The reason it lands at **5.5/10** rather than higher is execution rigor — the absence of tests, the DI pattern that quietly cancels Riverpod's benefits, a handful of real bugs in health-critical logic, and a privacy posture that isn't yet ready for a medical app at scale.

None of these are structural dead-ends. The architecture is sound enough that the fixes are additive, not a rewrite. Address testing and DI first (they unblock everything else, including the Riverpod 3 upgrade), tighten the privacy/logging story for the health domain, and this codebase moves into the 7.5–8 range without changing its fundamental shape.
