# Rules

## Code

- Put each feature in its own folder under `lib/src/features/<feature>/`, split into `data`, `domain`, `application`, `presentation`.
- Keep logic in Cubits, not in `build` methods. Split big widgets into small ones.
- Use spacing and size constants from `lib/src/constants/app_sizes.dart`. No raw numbers.
- Use `context.color` for colors. No hardcoded colors.
- Style widgets through the app theme (`lib/src/theme/`). Don't make wrapper widgets just for styling; use built-in widgets like `FilledButton`, `TextField`, `IconButton`.
- Put user-facing text in `lib/src/localization/app_en.arb` and read it with `context.loc`. Run `flutter gen-l10n` after editing it.
- Pin exact package versions in `pubspec.yaml`. No `^`.
- Run `dart run build_runner build` after changing drift tables.

## Before finishing a task

- `flutter analyze` must show 0 issues.
- `flutter test` must pass.

## Releases

- Never push a release or patch tag without asking first.
- Full release: bump `version` in `pubspec.yaml`, then tag `release-android-vX.X.X`.
- Shorebird patch: tag `patch-android-vX.X.X.X`.
