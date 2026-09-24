import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/routing/app_routes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/utils/date_formatter.dart';
import 'package:lifely/src/core/widgets/confirm_dialog.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// One task row: tap to open, tick to complete, swipe left to delete.
class const TaskTile({super.key, required final Task task})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskListController>();
    return Padding(
      padding: const .only(bottom: Sizes.p8),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: .endToStart,
        background: ColoredBox(color: context.color.error),
        confirmDismiss: (_) => _confirmDelete(context),
        onDismissed: (_) => controller.deleteTask(task.id),
        child: ListTile(
          onTap: () => context.pushNamed(
            AppRoute.taskDetails.name,
            pathParameters: {AppRoute.taskIdParam: '${task.id}'},
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? .lineThrough : null,
            ),
          ),
          subtitle: task.isCompleted
              ? null
              : Text(
                  '${context.loc.deadline} ${kDateFormatter.format(task.deadline)}',
                ),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => controller.toggleCompletion(task),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: context.loc.deleteTaskTitle,
      content: context.loc.deleteTaskBody,
      cancelText: context.loc.cancel,
      confirmText: context.loc.delete,
    );
    return confirmed ?? false;
  }
}
