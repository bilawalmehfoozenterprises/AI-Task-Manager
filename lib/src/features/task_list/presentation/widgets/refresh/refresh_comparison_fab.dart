import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/refresh_preview_options.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/refresh_comparison_sheet.dart';

const kRefreshComparisonKey = ValueKey('Refresh-Comparison');

/// Short landscape windows have no room for a third button, so the entry
/// point moves to the app bar instead.
bool useCompactRefreshEntry(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width > size.height && size.height < 480;
}

/// Temporary small button that opens the refresh comparison.
class RefreshComparisonFab extends StatelessWidget {
  const RefreshComparisonFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!refreshComparisonEnabled || useCompactRefreshEntry(context)) {
      return const SizedBox.shrink();
    }
    return FloatingActionButton.small(
      key: kRefreshComparisonKey,
      heroTag: 'refresh_comparison_fab',
      tooltip: context.loc.compareRefresh,
      onPressed: () => showRefreshComparisonSheet(context),
      child: const Icon(Icons.swap_horiz),
    );
  }
}

/// App-bar version of the same action, used on short landscape windows.
class RefreshComparisonAction extends StatelessWidget {
  const RefreshComparisonAction({super.key});

  @override
  Widget build(BuildContext context) {
    if (!refreshComparisonEnabled || !useCompactRefreshEntry(context)) {
      return const SizedBox.shrink();
    }
    return IconButton(
      key: kRefreshComparisonKey,
      tooltip: context.loc.compareRefresh,
      onPressed: () => showRefreshComparisonSheet(context),
      icon: const Icon(Icons.swap_horiz),
    );
  }
}
