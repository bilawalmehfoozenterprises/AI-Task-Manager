import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_effect_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_simulation.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_painter.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_sheet.dart';

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
  var _pixelRatio = 1.0;

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
    if (box is! RenderBox || burst.letters.isEmpty) return;
    final (sheet, spots) = drawLetterSheet(burst, _pixelRatio);
    final origin = box.globalToLocal(.zero);
    for (final (i, letter) in burst.letters.indexed) {
      final placed = Letter(letter.char, letter.rect.shift(origin));
      _simulation.add(placed, sheet, spots[i], burst.motion);
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
    // Letters are drawn sharp for this screen's pixel density.
    _pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return IgnorePointer(
      // Keeps each frame's redraw to the letters, not the list around them.
      child: RepaintBoundary(
        child: CustomPaint(
          painter: LetterPainter(_simulation, repaint: _repaint),
          size: .infinite,
        ),
      ),
    );
  }
}
