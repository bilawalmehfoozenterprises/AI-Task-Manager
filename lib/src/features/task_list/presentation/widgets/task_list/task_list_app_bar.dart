import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';

/// "My Tasks" with Pending/Completed tabs. On scroll the title hides and the
/// tabs stay pinned; scrolling up a little brings the title back.
class TaskListAppBar extends StatelessWidget {
  const TaskListAppBar({super.key, required this.isScrolled});

  /// True when the list is scrolled, to show the app bar's elevation.
  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        title: Text(context.loc.myTasks),
        // pinned + floating + bottom: only the tabs stay when collapsed.
        pinned: true,
        floating: true,
        snap: true,
        forceElevated: isScrolled,
        bottom: TabBar(
          tabs: [
            Tab(text: context.loc.pendingTab),
            Tab(text: context.loc.completedTab),
          ],
        ),
      ),
    );
  }
}
