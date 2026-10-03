import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_outcome.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_variant.dart';

/// Stand-in for the Rive animation: a simple icon that follows the pull.
/// Swap this widget for the Rive player once the assets are ready.
class TaskRefreshVisual extends StatelessWidget {
  const TaskRefreshVisual({
    super.key,
    required this.controller,
    required this.variant,
    required this.outcome,
  });

  final IndicatorController controller;
  final RefreshVariant variant;
  final RefreshOutcome? outcome;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final state = controller.state;
    final still = MediaQuery.disableAnimationsOf(context);
    final turns = still ? 0.0 : controller.value.clamp(0, 1).toDouble();
    return switch (state) {
      _ when state.isLoading => CircularProgressIndicator(color: color.primary),
      _ when state.isComplete || state.isFinalizing =>
        outcome == .failed
            ? Icon(Icons.error_outline, size: Sizes.p48, color: color.error)
            : Icon(Icons.check_circle, size: Sizes.p48, color: color.primary),
      _ => RotationTransition(
        turns: AlwaysStoppedAnimation(turns),
        child: Icon(
          variant == .tornado ? Icons.cyclone : Icons.pets,
          size: Sizes.p48,
          color: color.primary,
        ),
      ),
    };
  }
}
