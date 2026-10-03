import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_preview_controller.dart';
import 'package:lifely/src/features/task_list/presentation/refresh_preview_options.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/task_refresh_header.dart';

/// Adds pull-to-refresh to one tab. Does nothing unless the comparison is on.
/// [builder] gets the header sliver and scroll physics to give the list.
class TaskRefreshContainer extends StatefulWidget {
  const TaskRefreshContainer({
    super.key,
    required this.tabIndex,
    required this.builder,
  });

  final int tabIndex;
  final Widget Function(
    BuildContext context,
    Widget header,
    ScrollPhysics? physics,
  )
  builder;

  @override
  State<TaskRefreshContainer> createState() => _TaskRefreshContainerState();
}

class _TaskRefreshContainerState extends State<TaskRefreshContainer> {
  final _controller = IndicatorController();
  final _key = GlobalKey<CustomRefreshIndicatorState>();
  late final RefreshPreviewController _preview;
  late final void Function() _stopListening;
  int _handledRequests = 0;

  @override
  void initState() {
    super.initState();
    _preview = context.read<RefreshPreviewController>();
    _handledRequests = _preview.previewRequests.peek();
    _stopListening = effect(() {
      final requests = _preview.previewRequests.value;
      if (requests == _handledRequests) return;
      _handledRequests = requests;
      untracked(_startPreview);
    });
  }

  @override
  void dispose() {
    _stopListening();
    _controller.dispose();
    super.dispose();
  }

  bool get _isActiveTab =>
      DefaultTabController.of(context).index == widget.tabIndex;

  /// Scrolls to the top, then runs the same path as a real pull.
  Future<void> _startPreview() async {
    if (!mounted || !_isActiveTab || !_controller.state.isIdle) return;
    final nested = context.findAncestorStateOfType<NestedScrollViewState>();
    await nested?.outerController.animateTo(
      0,
      duration: refreshCollapseDuration,
      curve: Curves.ease,
    );
    if (!mounted) return;
    await _key.currentState?.refresh();
  }

  Future<void> _refresh() async {
    final outcome = await _preview.run();
    if (mounted && outcome == .failed) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.loc.refreshFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!refreshComparisonEnabled) {
      return widget.builder(context, const SliverToBoxAdapter(), null);
    }
    return CustomRefreshIndicator(
      key: _key,
      controller: _controller,
      autoRebuild: false,
      offsetToArmed: Sizes.refreshArmDistance,
      durations: const .new(
        cancelDuration: refreshCancelDuration,
        settleDuration: refreshSettleDuration,
        finalizeDuration: refreshCollapseDuration,
        completeDuration: refreshCompleteDuration,
      ),
      onRefresh: _refresh,
      onStateChanged: (change) {
        if (change.didChange(to: .armed)) HapticFeedback.lightImpact();
        if (change.didChange(to: .idle)) _preview.finish();
      },
      builder: (context, child, _) => child,
      child: widget.builder(
        context,
        TaskRefreshHeader(controller: _controller),
        AlwaysScrollableScrollPhysics(
          parent: ClampingWithOverscrollPhysics(state: _controller),
        ),
      ),
    );
  }
}
