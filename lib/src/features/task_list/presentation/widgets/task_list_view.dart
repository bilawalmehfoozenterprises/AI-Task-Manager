import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/centered_loading.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list_body.dart';

/// Shows loading, error, empty, or the list. Rebuilds when the tasks change.
class const TaskListView({super.key}) extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskListController>();
    return switch (controller.tasks.value) {
      AsyncError() => CenteredMessage(message: context.loc.loadTasksFailed),
      AsyncData(value: []) => CenteredMessage(
        message: context.loc.noTasksFound,
      ),
      AsyncData() => TaskListBody(
        pendingTasks: controller.pendingTasks.value,
        completedTasks: controller.completedTasks.value,
      ),
      AsyncLoading() => const CenteredLoading(),
    };
  }
}
