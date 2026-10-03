import 'package:material_ui/material_ui.dart';
import 'package:rive/rive.dart';

/// Phase numbers the .riv state machine understands.
enum RefreshPhase { pull, refreshing, complete, failed, reducedComplete }

/// Typed access to the `RefreshControls` view model of one artboard.
class RiveRefreshBinding {
  RiveRefreshBinding._(this._instance, this._pull, this._phase, this._colors);

  final ViewModelInstance _instance;
  final ViewModelInstanceNumber _pull;
  final ViewModelInstanceNumber _phase;
  final Map<String, ViewModelInstanceColor> _colors;

  /// Binds [controller] and checks every property exists.
  /// Throws a [StateError] naming the first one that is missing.
  factory RiveRefreshBinding.bind(RiveWidgetController controller) {
    final instance = controller.dataBind(DataBind.auto());
    T need<T>(T? value, String name) =>
        value ?? (throw StateError('Missing Rive property: $name'));
    return RiveRefreshBinding._(
      instance,
      need(instance.number('pullProgress'), 'pullProgress'),
      need(instance.number('phase'), 'phase'),
      {
        for (final name in _colorNames)
          name: need(instance.color(name), name),
      },
    );
  }

  static const _colorNames = ['accent', 'success', 'surfaceContrast'];

  void update({
    required double pull,
    required RefreshPhase phase,
    required Color accent,
    required Color success,
    required Color surfaceContrast,
  }) {
    _pull.value = pull.clamp(0, 1).toDouble();
    _phase.value = phase.index.toDouble();
    _colors['accent']!.value = accent;
    _colors['success']!.value = success;
    _colors['surfaceContrast']!.value = surfaceContrast;
  }

  void dispose() => _instance.dispose();
}
