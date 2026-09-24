import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/layout/window_size_class.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_section.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// Pending tasks on top, completed tasks below (only when there are some).
class const TaskListBody({
  super.key,
  required final List<Task> pendingTasks,
  required final List<Task> completedTasks,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: context.windowSizeClass.margin),
      child: Column(
        children: [
          Expanded(
            child: pendingTasks.isEmpty
                ? CenteredMessage(message: context.loc.noTasksFound)
                : TaskSection(tasks: pendingTasks),
          ),
          if (completedTasks.isNotEmpty)
            Expanded(
              child: TaskSection(
                title: context.loc.completedTasks,
                tasks: completedTasks,
              ),
            ),
        ],
      ),
    );
  }
}
