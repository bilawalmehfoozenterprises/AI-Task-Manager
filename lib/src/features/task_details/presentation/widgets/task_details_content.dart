import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/layout/window_size_class.dart';
import 'package:lifely/src/core/routing/app_routes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_details/presentation/widgets/task_deadline_row.dart';
import 'package:lifely/src/features/task_details/presentation/widgets/task_details_top_bar.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// Title, description, deadline, and the Edit button.
class const TaskDetailsContent({super.key, required final Task task})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(context.windowSizeClass.margin),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const .only(top: Sizes.p12),
              child: Column(
                spacing: Sizes.p24,
                crossAxisAlignment: .stretch,
                children: [
                  const TaskDetailsTopBar(),
                  Column(
                    spacing: Sizes.p8,
                    crossAxisAlignment: .stretch,
                    children: [
                      Text(task.title, style: context.txtTheme.titleLarge),
                      Text(
                        task.description,
                        style: context.txtTheme.bodyLarge?.copyWith(
                          color: context.color.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  TaskDeadlineRow(deadline: task.deadline),
                ],
              ),
            ),
          ),
          FilledButton(
            onPressed: () => context.pushNamed(
              AppRoute.editTask.name,
              pathParameters: {AppRoute.taskIdParam: '${task.id}'},
            ),
            child: Text(context.loc.editTask),
          ),
        ],
      ),
    );
  }
}
