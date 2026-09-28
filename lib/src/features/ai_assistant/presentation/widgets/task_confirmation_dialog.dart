import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/utils/date_formatter.dart';
import 'package:lifely/src/core/widgets/confirm_dialog.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';

/// Shows the AI's draft and asks whether to save it.
Future<bool?> showTaskConfirmationDialog({
  required BuildContext context,
  required TaskDraft draft,
}) {
  final loc = context.loc;
  return showConfirmDialog(
    context: context,
    title: loc.confirmTaskTitle,
    content:
        '${loc.title}: ${draft.title}\n'
        '${loc.description}: ${draft.description}\n'
        '${loc.deadline} ${kDateFormatter.format(draft.deadline)}',
    cancelText: loc.cancel,
    confirmText: loc.confirm,
  );
}
