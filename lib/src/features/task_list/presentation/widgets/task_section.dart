import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_tile.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// A scrollable group of tasks with an optional heading.
class const TaskSection({
  super.key,
  required final List<Task> tasks,
  final String? title,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final heading = title;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        if (heading != null)
          Card(
            margin: const .only(bottom: Sizes.p8),
            child: Padding(
              padding: const .symmetric(
                vertical: Sizes.p8,
                horizontal: Sizes.p16,
              ),
              child: Text(heading, style: context.txtTheme.titleMedium),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskTile(task: tasks[index]),
          ),
        ),
      ],
    );
  }
}
