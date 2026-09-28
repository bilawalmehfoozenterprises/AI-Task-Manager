import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/centered_loading.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_details/presentation/controller/task_details_controller.dart';
import 'package:lifely/src/features/task_details/presentation/widgets/task_details_content.dart';

/// Shows the task, or a message when it no longer exists.
class const TaskDetailsView({super.key}) extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskDetailsController>();
    return switch (controller.task.value) {
      AsyncData(value: final task?) => TaskDetailsContent(task: task),
      AsyncData() ||
      AsyncError() => CenteredMessage(message: context.loc.taskNotFound),
      AsyncLoading() => const CenteredLoading(),
    };
  }
}
