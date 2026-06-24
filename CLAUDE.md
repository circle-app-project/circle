# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Circle is a Flutter app for managing Sickle Cell disease — medication tracking, water intake, vitals, and emergency contacts. Backend is Firebase (Auth, Firestore, Crashlytics, Analytics); local persistence is ObjectBox.

## Commands

```bash
# Dependencies
flutter pub get

# Code generation (required after any changes to providers, routes, or ObjectBox entities)
flutter pub run build_runner build --delete-conflicting-outputs
# Watch mode during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Lint and static analysis
flutter analyze
dart fix --apply

# Tests
flutter test
flutter test test/path/to/specific_test.dart  # single test file

# Run app
flutter run

# Build
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

**Do not manually edit the version build number** (`pubspec.yaml` `+N`). CI/CD increments it automatically on release branches.

## Architecture

Feature-first layout under `lib/features/` with six features: `auth`, `meds`, `water`, `home`, `emergency`, `profile`. Each feature follows the same internal structure:

```
features/<name>/
  models/       # Plain Dart/ObjectBox entity classes
  services/     # Firebase + ObjectBox I/O (no business logic)
  repositories/ # Abstract interfaces + implementations; wrap services, convert exceptions to Failure
  providers/    # Riverpod notifiers; inject repositories, manage state
  screens/      # UI only — reads provider state, dispatches actions
```

Shared code lives in `lib/core/` (routing, theme, error types, extensions, utils) and `lib/components/` (reusable widgets).

### Data Flow

```
Screen → Notifier (Riverpod) → Repository → Service (Firebase/ObjectBox)
```

### Key Patterns

**Functional error handling** — all async operations return `FutureEither<T>` (`Future<Either<Failure, T>>`), defined in `core/utils/typedefs.dart`. Use **fpdart** `Either`/`TaskEither` throughout; avoid bare try/catch in repositories.

**Riverpod + code gen** — providers use `@Riverpod` annotation; generated base classes live in `*.g.dart` files. Notifiers extend `_$ClassName`. Run `build_runner` whenever annotations change.

**AutoRoute** — routes are declared in `lib/core/routes/routes.dart` and generated into `routes.gr.dart`. Add new routes there and regenerate.

**ObjectBox** — entities annotated with `@Entity()`. The store singleton is initialized in `lib/databse_service.dart` (note the typo in the filename). ObjectBox Admin runs on port 8091 in debug mode for inspecting the local DB.

### State Management Details

Notifiers receive repositories through their `build()` method (constructor injection via Riverpod). The pattern ensures testability — pass mock repositories in tests.

### Theme

Material 3. Colors, text styles, and spacing constants live in `lib/core/theme/`. Font is Plus Jakarta Sans. Don't hardcode colors or spacing — use `AppColors`, `AppTextStyles`, and `AppConstants`.

## Code Generation Files

These are generated — do not edit by hand:
- `lib/objectbox.g.dart`, `lib/objectbox-model.json`
- `lib/core/routes/routes.gr.dart`
- `lib/gen/assets.gen.dart`, `lib/gen/fonts.gen.dart`
- Any `*.g.dart` file alongside a provider/entity

## CI/CD

- PRs to `main`: runs `flutter analyze` + builds debug APK
- PRs from `release/*` to `main`: auto-increments version, builds release artifacts, deploys to Play Store internal track
- Create a `release/x.y.z` branch and PR to `main` to cut a release
