import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_effect_controller.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_simulation.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letter_painter.dart';

/// Draws flying task-title letters over the list. Taps pass through it.
/// The letters are cleared when the screen closes.
class const LetterLayer({super.key}) extends StatefulWidget {
  @override
  State<LetterLayer> createState() => _LetterLayerState();
}

class _LetterLayerState extends State<LetterLayer>
    with SingleTickerProviderStateMixin {
  /// Longest step per frame, so a slow frame can't make letters jump.
  static const _maxStep = 1 / 30;

  final _simulation = LetterSimulation(Random());
  final _repaint = ValueNotifier(0);
  late final _ticker = createTicker(_onTick);
  late final EffectCleanup _stopListening;
  var _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    final controller = context.read<LetterEffectController>();
    _stopListening = effect(() {
      controller.requests.value;
      controller.takeAll().forEach(_add);
    });
  }

  @override
  void dispose() {
    _stopListening();
    _ticker.dispose();
    _repaint.dispose();
    _simulation.dispose();
    super.dispose();
  }

  void _add(LetterBurst burst) {
    final box = context.findRenderObject();
    if (box is! RenderBox) return;
    for (final letter in burst.letters) {
      final glyph = TextPainter(
        text: TextSpan(text: letter.char, style: burst.style),
        textDirection: .ltr,
        textScaler: burst.textScaler,
      )..layout();
      final rect = letter.rect.shift(box.globalToLocal(.zero));
      _simulation.add(Letter(letter.char, rect), glyph, burst.motion);
    }
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final seconds = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _simulation.step(min(seconds, _maxStep), context.size ?? .zero);
    _repaint.value++;
    if (_simulation.isIdle) _ticker.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: LetterPainter(_simulation, repaint: _repaint),
        size: .infinite,
      ),
    );
  }
}
