import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/task_refresh_container.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list/task_tile.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// One tab's tasks, or [emptyMessage] when there are none.
/// Scrolls together with the app bar and remembers its own scroll position.
class TaskTab extends StatelessWidget {
  const TaskTab({
    super.key,
    required this.name,
    required this.tabIndex,
    required this.tasks,
    required this.emptyMessage,
  });

  /// Unique per tab, so each tab keeps its scroll position.
  final String name;
  final int tabIndex;
  final List<Task> tasks;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return TaskRefreshContainer(
      tabIndex: tabIndex,
      builder: (context, header, physics) => _list(context, header, physics),
    );
  }

  Widget _list(BuildContext context, Widget header, ScrollPhysics? physics) {
    return CustomScrollView(
      key: PageStorageKey(name),
      physics: physics,
      slivers: [
        // Keeps the first task from sliding under the pinned tabs.
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        header,
        if (tasks.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: CenteredMessage(message: emptyMessage),
          )
        else
          SliverList.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskTile(task: tasks[index]),
          ),
      ],
    );
  }
}
