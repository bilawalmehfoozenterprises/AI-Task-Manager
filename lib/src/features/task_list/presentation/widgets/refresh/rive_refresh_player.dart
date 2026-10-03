import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/core/theme/colors.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_outcome.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_variant.dart';
import 'package:lifely/src/features/task_list/presentation/refresh_preview_options.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/refresh_rive_file.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/rive_refresh_binding.dart';

/// Plays one artboard of the comparison file and feeds it the pull state.
/// Shows [fallback] while loading or if the animation is unavailable.
class RiveRefreshPlayer extends StatefulWidget {
  const RiveRefreshPlayer({
    super.key,
    required this.controller,
    required this.variant,
    required this.outcome,
    required this.fallback,
  });

  final IndicatorController controller;
  final RefreshVariant variant;
  final RefreshOutcome? outcome;
  final Widget fallback;

  @override
  State<RiveRefreshPlayer> createState() => _RiveRefreshPlayerState();
}

class _RiveRefreshPlayerState extends State<RiveRefreshPlayer> {
  RiveWidgetController? _rive;
  RiveRefreshBinding? _binding;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
    _open();
  }

  Future<void> _open() async {
    final loader = context.read<RefreshRiveFile>();
    final logger = context.read<Logger>();
    final file = await loader.load();
    if (file == null || _disposed) return;
    try {
      final rive = RiveWidgetController(
        file,
        artboardSelector: .byName(widget.variant.artboard),
        stateMachineSelector: .byName(refreshRiveStateMachine),
      );
      _rive = rive;
      _binding = RiveRefreshBinding.bind(rive);
    } on Object catch (error, stackTrace) {
      logger.severe(
        'Refresh animation contract failed (${widget.variant.name})',
        error: error,
        stackTrace: stackTrace,
      );
      _close();
    }
    if (mounted) setState(() {});
    _sync();
  }

  void _close() {
    _binding?.dispose();
    _rive?.dispose();
    _binding = null;
    _rive = null;
  }

  RefreshPhase get _phase {
    final state = widget.controller.state;
    if (state.isLoading) return .refreshing;
    if (!state.isComplete && !state.isFinalizing) return .pull;
    if (widget.outcome == .failed) return .failed;
    return MediaQuery.disableAnimationsOf(context)
        ? .reducedComplete
        : .complete;
  }

  void _sync() {
    final binding = _binding;
    if (binding == null || !mounted) return;
    final color = context.color;
    final phase = _phase;
    binding.update(
      pull: phase == .pull ? widget.controller.value : 1,
      phase: phase,
      accent: color.primary,
      success: darkSuccessColor,
      surfaceContrast: color.onSurface,
    );
  }

  @override
  void didUpdateWidget(RiveRefreshPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _disposed = true;
    widget.controller.removeListener(_sync);
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rive = _rive;
    if (rive == null || _binding == null) return widget.fallback;
    return RiveWidget(controller: rive, fit: .contain);
  }
}
