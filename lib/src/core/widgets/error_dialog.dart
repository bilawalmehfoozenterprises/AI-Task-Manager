import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';

/// Shows an error message with a single OK button.
Future<void> showErrorDialog({
  required BuildContext context,
  required String message,
  String? title,
}) {
  return showAdaptiveDialog<void>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: title != null ? Text(title) : null,
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.ok),
        ),
      ],
    ),
  );
}
