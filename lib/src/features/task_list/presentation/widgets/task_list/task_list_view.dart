import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/centered_loading.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list/task_tab.dart';

/// Loading, error, or the two tabs' lists. Rebuilds when the tasks change.
class TaskListView extends SignalWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskListController>();
    return switch (controller.tasks.value) {
      AsyncError() => CenteredMessage(message: context.loc.loadTasksFailed),
      AsyncData() => TabBarView(
        children: [
          TaskTab(
            name: 'pending',
            tasks: controller.pendingTasks.value,
            emptyMessage: context.loc.noTasksFound,
          ),
          TaskTab(
            name: 'completed',
            tasks: controller.completedTasks.value,
            emptyMessage: context.loc.noCompletedTasks,
          ),
        ],
      ),
      AsyncLoading() => const CenteredLoading(),
    };
  }
}
