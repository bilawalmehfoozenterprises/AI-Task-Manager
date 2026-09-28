# Rules

## Architecture

- Every screen or capability is its own feature folder: `lib/src/features/<feature>/` (e.g. `task_list`, `task_details`, `task_editor`, `ai_assistant`).
- Split each feature into the layers it needs; skip a layer only when it has nothing:
  - `domain/`: immutable models (Equatable, `fromJson`/`toJson` with plain maps). No Flutter or package types.
  - `data/`: repositories and the data sources they wrap (Drift, Gemini, speech). Only this layer talks to those packages.
  - `application/`: services, only when logic combines repositories or has real rules (e.g. validate then save).
  - `presentation/`: `controller/` (controllers + result types) and `widgets/`, plus the `*_screen.dart`.
- Dependencies point one way: presentation → application → data; every layer may use domain.
- Features never import each other. Shared code lives in `lib/src/shared/<name>/` (used by 2+ features) or `lib/src/core/` (app-wide basics). App startup and routing live in `lib/src/app/`.
- Keep repositories small: each feature gets its own repository with only the methods it needs. Don't build one big shared repository.
- Keep row/companion mapping (Drift types) in `data/`, never in domain models.
- Prefer streams from Drift for data that can change elsewhere; don't hand-roll reload/invalidate logic.

## State and dependencies

- State management is `signals_flutter`. Controllers are plain classes holding signals (`signal`, `computed`, `streamSignal`) with a `dispose()` method.
- Screen state (loading, saving, messages) belongs in the controller in `presentation/`, not in `domain/`.
- Widgets that read signals extend `SignalWidget`, or use `SignalBuilder` for a small part. Don't use the deprecated `Watch`, `.watch(context)`, or `SignalsMixin`; use `effect()` and call its cleanup in `dispose`.
- For one-off results (saved, invalid, failed), controller methods return a result and the widget reacts; don't add listener state for it.
- Provide dependencies with `provider`, scoped to the screen that needs them (`MultiProvider` in `*_screen.dart`, with `dispose:` for controllers). Only the `Logger` and the database are app-wide (`app/app_scope.dart`).

## Navigation

- Use `go_router`. Every screen has an entry in the `AppRoute` enum (`core/routing/app_routes.dart`); paths live in `app/router.dart`.
- Navigate by name: `context.pushNamed(AppRoute.x.name)` when the user should be able to go back, `context.goNamed(...)` to jump and replace the history.

## Code

- One job per file. Aim for under 100 lines; never over 150.
- Never use `dynamic`; use `Object?` and check types. The analyzer enforces this (strict casts, inference, raw types, `avoid_dynamic_calls`).
- Use primary constructors and dot shorthands wherever the language allows.
- Import `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`. Don't import `cupertino_ui` directly; for iOS styling use Material's `.adaptive` widgets (e.g. `showAdaptiveDialog`, `AlertDialog.adaptive`).
- Style widgets through the app theme (`lib/src/core/theme/`). Don't make wrapper widgets just for styling; use built-in widgets like `FilledButton`, `TextField`, `IconButton`.
- For layout, use Material 3 window size classes (`core/layout/window_size_class.dart`, `context.windowSizeClass`).
- Use spacing and size constants from `lib/src/core/constants/app_sizes.dart`. No raw numbers.
- Space children with `Row`/`Column`'s `spacing:` (e.g. `spacing: Sizes.p16`), not gap widgets between them. For scrolling content, use a `SingleChildScrollView` with a `Column`.
- Use `context.color` for colors. No hardcoded colors.
- Put user-facing text in `lib/src/core/localization/app_en.arb` and read it with `context.loc`. Run `flutter gen-l10n` after editing it.
- Pin exact package versions in `pubspec.yaml`. No `^`.
- Run `dart run build_runner build` after changing Drift tables.

## Tests

- A file's test mirrors its path: `lib/src/a/b/c.dart` → `test/src/a/b/c_test.dart`.
- Shared test helpers live in `test/helpers/`.

## Before finishing a task

- `flutter analyze` must show 0 issues.
- `flutter test` must pass.

## Running the app

- Run with `flutter run --print-dtd` so the Dart MCP server can connect to the running app (hot reload, runtime errors, widget inspector).

## Releases

- Never push a release or patch tag without asking first.
- Full release: bump `version` in `pubspec.yaml`, then tag `release-android-vX.X.X`.
- Shorebird patch: tag `patch-android-vX.X.X.X`.
