import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_preview_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/rive_refresh_player.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/task_refresh_visual.dart';

/// Zero height at rest. Grows with the pull and pushes the list down.
class TaskRefreshHeader extends SignalWidget {
  const TaskRefreshHeader({super.key, required this.controller});

  final IndicatorController controller;

  @override
  Widget build(BuildContext context) {
    final preview = context.read<RefreshPreviewController>();
    final variant = preview.latched.value ?? preview.selected.value;
    final outcome = preview.outcome.value;
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final extent = (controller.value * Sizes.refreshSettledExtent).clamp(
            0.0,
            Sizes.refreshMaxExtent,
          );
          return Semantics(
            liveRegion: true,
            label: _label(context),
            child: ExcludeSemantics(
              child: ClipRect(
                child: ColoredBox(
                  color: context.color.surface,
                  child: SizedBox(
                    height: extent,
                    child: OverflowBox(
                      minWidth: 0,
                      minHeight: 0,
                      maxHeight: Sizes.refreshSettledExtent,
                      maxWidth: Sizes.refreshVisualWidth,
                      child: RepaintBoundary(
                        child: controller.state.isIdle
                            ? const SizedBox.shrink()
                            : RiveRefreshPlayer(
                                key: ValueKey(variant),
                                controller: controller,
                                variant: variant,
                                outcome: outcome,
                                fallback: TaskRefreshVisual(
                                  controller: controller,
                                  variant: variant,
                                  outcome: outcome,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _label(BuildContext context) {
    final state = controller.state;
    if (state.isArmed) return context.loc.refreshReady;
    if (state.isLoading) return context.loc.refreshWorking;
    if (state.isComplete) return context.loc.refreshDone;
    return '';
  }
}
