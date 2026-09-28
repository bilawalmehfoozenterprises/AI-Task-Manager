import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_particle.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_simulation.dart';

/// Draws each flying letter at its place, turned and faded. Letters of one
/// task title share a sheet, so each title is drawn in a single call.
class LetterPainter(final LetterSimulation _simulation, {super.repaint})
    extends CustomPainter {
  final _paint = Paint()..filterQuality = .medium;

  @override
  void paint(Canvas canvas, Size size) {
    final particles = _simulation.particles;
    var start = 0;
    for (var i = 1; i <= particles.length; i++) {
      if (i < particles.length &&
          particles[i].sheet == particles[start].sheet) {
        continue;
      }
      _drawBatch(canvas, particles.sublist(start, i));
      start = i;
    }
  }

  /// Draws letters that share one sheet with a single draw call.
  void _drawBatch(Canvas canvas, List<LetterParticle> batch) {
    final sheet = batch.first.sheet;
    canvas.drawAtlas(
      sheet.image,
      [
        for (final p in batch)
          RSTransform.fromComponents(
            rotation: p.angle,
            scale: 1 / sheet.pixelRatio,
            anchorX: p.spot.width / 2,
            anchorY: p.spot.height / 2,
            translateX: p.position.dx,
            translateY: p.position.dy,
          ),
      ],
      [for (final p in batch) p.spot],
      // White scaled by opacity, multiplied into the letter: fades it.
      [for (final p in batch) Color.fromRGBO(255, 255, 255, p.opacity)],
      .modulate,
      null,
      _paint,
    );
  }

  @override
  bool shouldRepaint(LetterPainter oldDelegate) =>
      oldDelegate._simulation != _simulation;
}
