import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/layout/window_size_class.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_tile.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// One tab's tasks, or [emptyMessage] when there are none.
/// Scrolls together with the app bar and remembers its own scroll position.
class TaskTab extends StatelessWidget {
  const TaskTab({
    super.key,
    required this.name,
    required this.tasks,
    required this.emptyMessage,
  });

  /// Unique per tab, so each tab keeps its scroll position.
  final String name;
  final List<Task> tasks;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey(name),
      slivers: [
        // Keeps the first task from sliding under the pinned tabs.
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (tasks.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: CenteredMessage(message: emptyMessage),
          )
        else
          SliverPadding(
            padding: .symmetric(
              horizontal: context.windowSizeClass.margin,
              vertical: Sizes.p8,
            ),
            sliver: SliverList.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskTile(task: tasks[index]),
            ),
          ),
      ],
    );
  }
}
