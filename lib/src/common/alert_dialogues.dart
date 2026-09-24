import 'package:material_ui/material_ui.dart';
import 'package:todo_app/src/utils/extensions.dart';

/// Shows a confirm dialog: Cupertino style on iOS/macOS, Material elsewhere.
/// Returns true for the default action.
Future<bool?> showCustomAlertDialog({
  required BuildContext context,
  String? title,
  String? content,
  String? cancelActionText,
  String? defaultActionText,
}) {
  return showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: title != null ? Text(title) : null,
      content: content != null ? Text(content) : null,
      actions: [
        if (cancelActionText != null)
          TextButton(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        if (defaultActionText != null)
          FilledButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
      ],
    ),
  );
}

/// Shows a Material error dialog with a single OK button.
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  String? title,
  required dynamic exception,
}) => showCustomAlertDialog(
  context: context,
  title: title,
  content: exception.toString(),
  defaultActionText: context.loc.ok,
);
