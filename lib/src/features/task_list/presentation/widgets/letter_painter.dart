import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_simulation.dart';

/// Draws each flying letter at its place, turned and faded.
class LetterPainter(final LetterSimulation _simulation, {super.repaint})
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _simulation.particles) {
      final box = Offset(-p.size.width / 2, -p.size.height / 2) & p.size;
      canvas
        ..save()
        ..translate(p.position.dx, p.position.dy)
        ..rotate(p.angle);
      final fading = p.opacity < 1;
      if (fading) {
        canvas.saveLayer(
          box,
          Paint()..color = Color.fromRGBO(0, 0, 0, p.opacity),
        );
      }
      p.glyph.paint(canvas, box.topLeft);
      if (fading) canvas.restore();
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(LetterPainter oldDelegate) =>
      oldDelegate._simulation != _simulation;
}
