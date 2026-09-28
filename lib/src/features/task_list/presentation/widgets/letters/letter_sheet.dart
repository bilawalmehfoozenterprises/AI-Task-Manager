import 'dart:math';
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';

/// One image holding every letter of a task title, shared by those letters
/// so they can all be drawn in a single call. The image is freed once the
/// last letter using it is gone.
class LetterSheet(
  final ui.Image image,
  final double pixelRatio,
  var int _users,
) {
  /// Called by each letter when it is gone.
  void release() {
    _users--;
    if (_users == 0) image.dispose();
  }
}

/// Space between letters on the sheet, so they don't bleed into each other.
const _gap = 2.0;

/// Widest row on the sheet before letters wrap to the next row.
const _maxRow = 1024.0;

/// Draws each letter of [burst] once onto a new [LetterSheet], sharp at
/// [pixelRatio]. Returns the sheet and each letter's spot on it, in pixels.
(LetterSheet, List<Rect>) drawLetterSheet(
  LetterBurst burst,
  double pixelRatio,
) {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(pixelRatio);
  final spots = <Rect>[];
  var x = 0.0;
  var y = 0.0;
  var rowHeight = 0.0;
  var width = 0.0;
  for (final letter in burst.letters) {
    final painter = TextPainter(
      text: TextSpan(text: letter.char, style: burst.style),
      textDirection: .ltr,
      textScaler: burst.textScaler,
    )..layout();
    if (x > 0 && x + painter.width > _maxRow) {
      x = 0;
      y += rowHeight + _gap;
      rowHeight = 0;
    }
    painter.paint(canvas, Offset(x, y));
    spots.add(Offset(x, y) * pixelRatio & painter.size * pixelRatio);
    x += painter.width + _gap;
    width = max(width, x);
    rowHeight = max(rowHeight, painter.height);
    painter.dispose();
  }
  final picture = recorder.endRecording();
  final image = picture.toImageSync(
    max(1, (width * pixelRatio).ceil()),
    max(1, ((y + rowHeight) * pixelRatio).ceil()),
  );
  picture.dispose();
  return (LetterSheet(image, pixelRatio, burst.letters.length), spots);
}
