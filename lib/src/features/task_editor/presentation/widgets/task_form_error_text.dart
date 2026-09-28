import 'package:lifely/src/core/localization/app_localizations.dart';
import 'package:lifely/src/features/task_editor/domain/task_form_error.dart';

/// The message shown to the user for each form error.
extension TaskFormErrorText on TaskFormError {
  String message(AppLocalizations loc) => switch (this) {
    .emptyTitle => loc.emptyTitle,
    .emptyDescription => loc.emptyDescription,
    .missingDeadline => loc.missingDeadline,
  };
}
