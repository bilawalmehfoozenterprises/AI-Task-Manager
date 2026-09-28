import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';

/// Breaks the task title shown by [title] into letters, each placed where it
/// is drawn on screen. [row] is the task row; [tile] is the part of the row
/// that slides when swiping, so the letters start where the title was
/// before the swipe. Returns null when the title is not on screen.
LetterBurst? taskTitleLetters({
  required BuildContext row,
  required GlobalKey title,
  required GlobalKey tile,
  required LetterMotion motion,
}) {
  final paragraph = title.currentContext?.findRenderObject();
  final tileBox = tile.currentContext?.findRenderObject();
  final rowBox = row.findRenderObject();
  if (paragraph is! RenderParagraph ||
      tileBox is! RenderBox ||
      rowBox is! RenderBox ||
      !paragraph.hasSize) {
    return null;
  }
  final start =
      rowBox.localToGlobal(.zero) +
      paragraph.localToGlobal(.zero, ancestor: tileBox);

  final text = paragraph.text.toPlainText();
  final letters = <Letter>[];
  var offset = 0;
  for (final char in text.characters) {
    final end = offset + char.length;
    if (char.trim().isNotEmpty) {
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: offset, extentOffset: end),
      );
      if (boxes.isNotEmpty) {
        letters.add(Letter(char, boxes.first.toRect().shift(start)));
      }
    }
    offset = end;
  }

  final style = paragraph.text.style ?? const TextStyle();
  return LetterBurst(
    letters: letters,
    // Plain letters in the theme's text color, without the strike-through.
    style: style.copyWith(color: row.color.onSurface, decoration: .none),
    textScaler: paragraph.textScaler,
    motion: motion,
  );
}
