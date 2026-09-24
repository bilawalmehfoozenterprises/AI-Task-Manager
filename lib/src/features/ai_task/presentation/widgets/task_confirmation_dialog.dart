import 'package:material_ui/material_ui.dart';
import 'package:todo_app/src/common/alert_dialogues.dart';
import 'package:todo_app/src/features/ai_task/domain/ai_task_draft.dart';
import 'package:todo_app/src/utils/extensions.dart';

Future<bool?> showTaskConfirmationDialog({
  required BuildContext context,
  required AiTaskDraft draft,
}) {
  return showCustomAlertDialog(
    context: context,
    title: context.loc.confirmTaskTitle,
    content:
        '${context.loc.title}: ${draft.title}\n'
        '${context.loc.description}: ${draft.description}\n'
        '${context.loc.deadline}: ${draft.deadline.toIso8601String().split('T').first}',
    defaultActionText: context.loc.confirmButton,
    cancelActionText: context.loc.cancelButton,
  );
}
