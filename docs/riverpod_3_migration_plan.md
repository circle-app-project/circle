# Riverpod 2.x → 3.0 Migration Plan

**Companion to:** [`codebase_audit.md`](./codebase_audit.md)
**Date:** 2026-06-24
**Current versions:** `flutter_riverpod ^2.6.1`, `riverpod_annotation ^2.6.1`, `riverpod_generator ^2.6.3`, `riverpod_lint ^2.6.3`
**Target:** Riverpod 3.x (unified package, codegen)

---

## 1. TL;DR — Effort & Risk

| | Assessment |
|---|---|
| **Migration surface** | **Small.** 8 code-generated `@Riverpod` notifiers + 1 functional `Provider`. ~85 `ref.watch`, 9 `ref.read`, 1 `ref.listen`. 53 `Consumer*` widgets. **No legacy `StateProvider`/`StateNotifierProvider`/`ChangeNotifierProvider`/`StateNotifier` to port** — this is the part that makes most migrations painful, and you have none of it. |
| **Mechanical effort** | **Low–moderate** — bump deps, regenerate, fix the handful of API renames. A day or less of pure code changes. |
| **Real effort driver** | **The DI refactor (audit §3.2) and the absence of tests.** Without a test suite, every behavioral change in Riverpod 3 (auto-retry, provider pausing) must be verified by hand across all screens. |
| **Total estimate** | **~2–4 focused days**, front-loaded if you also fix DI (recommended). Add ~1–2 days if you build a smoke-test suite first (strongly recommended). |
| **Overall risk** | **Medium** — low code volume, but no automated safety net and a few behavioral defaults change in v3. |

**Recommendation:** Do this on a dedicated branch, fix the global-singleton DI as part of it (the two refactors touch the same files), and write at least a thin notifier/repository test layer *first* so you can detect regressions.

---

## 2. What Actually Changes in Riverpod 3 (relevant to this codebase)

Riverpod 3 is a smaller break than 1→2 for codegen users, but several defaults change behavior. The items below are the ones that touch *this* code.

### 2.1 Single unified package
`riverpod`, `flutter_riverpod`, and `hooks_riverpod` are consolidated and re-versioned to 3.x. You bump all Riverpod deps together. Codegen output targets the new API.

### 2.2 Generic `Ref` (codegen) — **affects generated code, not yours much**
In v2 codegen, each provider got a typed ref (e.g. `MedNotifierRef`). In v3 there is a single generic `Ref`. This codebase **does not reference the per-provider `…Ref` types by name** (notifiers use `ref.watch`/`ref.read` directly inside the class, and the one functional provider uses an untyped `ref`), so regeneration absorbs almost all of this. Verify after regen that no manual reference to a `…Ref` typedef remains.

### 2.3 Automatic retry — **behavioral change, verify**
v3 providers **automatically retry on error by default** (exponential backoff). Today the app surfaces failures as `AsyncValue.error` and the UI presumably shows an error state. With auto-retry, a failed provider may silently re-run. Decide per-provider whether to keep, tune, or disable retry (`@Riverpod(retry: ...)` / scope-level `retry`). For notifiers that fail on, e.g., a permanent local error, you likely want to disable retry to avoid loops.

### 2.4 Provider pausing when not observed — **behavioral change, verify**
v3 can pause providers whose listeners are not currently visible (e.g. off-screen). Your notifiers are all `@Riverpod(keepAlive: true)`, which mitigates disposal, but pausing semantics around `ref.watch`-driven recomputation (e.g. `waterStatsProvider`, and `MedNotifier` watching `userNotifierProviderImpl`) should be smoke-tested.

### 2.5 `AsyncValue` / error handling refinements
- `AsyncValue` retains previous data more consistently across loading/error transitions in v3. Code that assumes `state.value` is null during loading may now see stale-but-present data. Your `log("Success ${state.value}")` and any UI reading `.value` during loading should be reviewed (you're removing most of that logging per the audit anyway).
- Error/stacktrace handling around `AsyncError` is stricter. This is a **good moment** to remove the `failure.stackTrace!` force-unwraps (audit §3.3) since you're touching every notifier.

### 2.6 Legacy API moved behind `legacy` import
`StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`, and `StateNotifier` are deprecated/moved. **Not used here** — no action required, which is the single biggest reason this migration is cheap.

### 2.7 Experimental features you may *opt into* later (not required)
- **Offline persistence** (`@JsonPersist` / persistence API) — could eventually replace some of the manual ObjectBox-as-cache plumbing, but out of scope for the upgrade itself.
- **Mutations** (experimental) — a cleaner way to model the side-effecting notifier methods (`putMedication`, etc.) than the current manual loading/fold blocks. Worth piloting *after* the upgrade stabilizes.

### 2.8 Tooling
`riverpod_generator`, `riverpod_lint`, and `custom_lint` must move to 3.x-compatible versions in lockstep. `build_runner` stays. Expect the generator to require a clean rebuild (`--delete-conflicting-outputs`).

---

## 3. Pre-Migration Checklist (do these first)

1. **Branch:** create `chore/riverpod-3` off `main` (not off `code-audit`).
2. **Green baseline:** confirm `flutter analyze` is clean (it currently is, modulo 2 `Radio` infos) and the app builds/runs on Android.
3. **Write a smoke-test safety net** (the most important prerequisite given §1):
   - Unit tests for `futureHandler`/`methodHandler` mapping.
   - Model round-trip tests (`Medication`/`Dose`/`Frequency` `toMap`/`fromMap`, ObjectBox converters).
   - One notifier test per feature using `ProviderContainer` with an overridden repository — this *also* forces the DI fix in §4.
   - A handful of widget smoke tests for the primary screens (renders without throwing, shows data/error/loading).
4. **Snapshot current behavior** of error states and loading spinners on key screens (auth, meds list, water) so you can compare after auto-retry/pausing changes.

---

## 4. Fix DI as Part of the Migration (recommended, audit §3.2)

The current pattern — global `final` singletons + `build({required Repository repository})` family seam — is awkward under v2 and stays awkward under v3. Migrate it to provider-based DI in the same pass, because it touches the same files and unblocks testing (which you need to verify the migration).

**Target shape per feature:**
```dart
// services/repositories exposed as providers
@riverpod
MedLocalService medLocalService(Ref ref) =>
    MedLocalService(store: ref.watch(databaseStoreProvider));

@riverpod
MedService medService(Ref ref) => MedService();

@riverpod
MedRepository medRepository(Ref ref) => MedRepositoryImpl(
      medLocalService: ref.watch(medLocalServiceProvider),
      medService: ref.watch(medServiceProvider),
    );

@Riverpod(keepAlive: true)
class MedNotifier extends _$MedNotifier {
  @override
  FutureOr<List<Medication>> build() async {
    _repo = ref.watch(medRepositoryProvider);   // no more family param
    _selfUser = ref.watch(userNotifierProvider).value;
    return [];
  }
}
```
- Expose the ObjectBox `Store` as a provider (`databaseStoreProvider`) overridden in `main()` after `LocalDatabaseService.instance.initialize()`, instead of reading the global `database.store` at file-load time.
- Delete the `…ProviderImpl` / `…ProviderIml` globals; UI watches the generated provider directly (`ref.watch(medNotifierProvider)`).
- Tests then do `ProviderScope(overrides: [medRepositoryProvider.overrideWithValue(mockRepo)])`.

If you want to keep the migration purely mechanical and defer DI, you *can* — v3 still supports family parameters — but you'd be carrying the un-testability that makes the migration risky. Doing both together is the better trade.

---

## 5. Step-by-Step Migration

1. **Bump dependencies** in `pubspec.yaml` to the 3.x line (all in lockstep):
   - `flutter_riverpod`, `riverpod_annotation` → ^3.x
   - `riverpod_generator`, `riverpod_lint` → ^3.x (dev)
   - keep `custom_lint`, `build_runner` current/compatible
   - `flutter pub get` and resolve any version conflicts (e.g. `analyzer`/`build` transitive bumps).
2. **Regenerate:** `dart run build_runner build --delete-conflicting-outputs`. Expect changed `*.g.dart` (generic `Ref`, new family/provider shapes).
3. **Fix compile errors** — they will cluster around:
   - any direct use of a `…Ref` typedef (none expected here),
   - the family-parameter providers if you keep them (signature shifts), or their removal if you do §4,
   - `AsyncValue`/`AsyncError` construction sites (the `stackTrace!` unwraps — replace with `AsyncValue.guard` or `?? StackTrace.current`).
4. **Run `flutter analyze` and `dart run custom_lint`** — `riverpod_lint` 3.x will flag deprecated patterns; clear them.
5. **Configure retry** (§2.3): decide global vs per-provider; for local-storage-backed notifiers consider disabling auto-retry to avoid loops on deterministic failures.
6. **Run the smoke-test suite** from §3; fix regressions.
7. **Manual QA pass** on every screen, paying attention to: loading spinners, error displays, the `waterStatsProvider` recomputation, `MedNotifier`'s dependency on the user provider, and the auth stream subscription in `AuthNotifier.authStateChanges()` (move it into `build` with `ref.onDispose` while you're here — audit §3.7).
8. **Update `CLAUDE.md`** to describe provider-based DI (it currently documents the `build()`-injection pattern).

---

## 6. Effort Breakdown

| Task | Estimate | Notes |
|---|---|---|
| Pre-migration smoke tests | 1–2 days | Optional but strongly recommended; reduces risk the most |
| Dep bump + regenerate + fix compile errors | 0.5 day | Small surface; mostly generated code |
| DI refactor to providers (§4) | 0.5–1 day | Touches 4 provider files + their UI watchers (~85 `ref.watch` sites, mostly unchanged names if you keep generated provider names) |
| Retry/pausing config + behavioral verification | 0.5 day | Depends on how many screens to QA |
| Manual QA + fixes | 0.5–1 day | The long pole given no tests |
| **Total** | **~2–4 days** (+1–2 if building tests first) | |

---

## 7. Go / No-Go

**Reasons to do it now:** small surface, no legacy providers, you get auto-retry/persistence/mutations on the table, and you can fix the DI anti-pattern in the same motion. Riverpod 2 is in maintenance.

**Reasons to wait:** the **no-tests** situation is the real blocker. Migrating a health app's state layer with zero automated coverage and shipping to users is the risk, not the API churn.

**Recommended sequence:**
1. Build the smoke-test safety net (valuable regardless of the upgrade).
2. Fix DI (audit §3.2) — small, high-leverage, makes tests easy.
3. Then migrate to Riverpod 3 on top of that foundation.

Doing 1→2→3 turns a medium-risk migration into a low-risk one and leaves the codebase materially better than a straight version bump would.
