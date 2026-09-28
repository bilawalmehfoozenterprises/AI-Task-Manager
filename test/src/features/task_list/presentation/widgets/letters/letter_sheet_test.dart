import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_sheet.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  LetterBurst burstOf(String text) => LetterBurst(
    letters: [for (final char in text.split('')) Letter(char, Rect.zero)],
    style: const TextStyle(fontSize: 16),
    textScaler: .noScaling,
    motion: .fall,
  );

  void releaseAll(LetterSheet sheet, List<Rect> spots) {
    for (final _ in spots) {
      sheet.release();
    }
  }

  test('draws every letter side by side, sized for the pixel ratio', () {
    final (sheet, spots) = drawLetterSheet(burstOf('abc'), 2);
    addTearDown(() => releaseAll(sheet, spots));

    expect(spots, hasLength(3));
    expect(spots[0].height, 32);
    expect(spots[1].left, greaterThan(spots[0].right));
    expect(sheet.image.width, greaterThanOrEqualTo(spots[2].right));
  });

  test('wraps long titles onto more rows', () {
    final (sheet, spots) = drawLetterSheet(burstOf('x' * 200), 1);
    addTearDown(() => releaseAll(sheet, spots));

    expect(spots.last.top, greaterThan(0));
    expect(sheet.image.width, lessThanOrEqualTo(1100));
  });

  test('frees the image once every letter has released it', () {
    final (sheet, _) = drawLetterSheet(burstOf('ab'), 1);

    sheet.release();
    expect(sheet.image.debugDisposed, isFalse);
    sheet.release();
    expect(sheet.image.debugDisposed, isTrue);
  });
}
