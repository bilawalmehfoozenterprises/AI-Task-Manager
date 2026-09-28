import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_pile.dart';

void main() {
  late LetterPile pile;

  setUp(() => pile = LetterPile()..clear(100));

  test('is flat when empty', () {
    expect(pile.height(0, 100), 0);
  });

  test('reports the highest point in a range', () {
    pile.raise(10, 20, 5);
    pile.raise(30, 40, 12);

    expect(pile.height(0, 25), 5);
    expect(pile.height(0, 100), 12);
    expect(pile.height(50, 60), 0);
  });

  test('never lowers a column', () {
    pile.raise(10, 20, 12);
    pile.raise(10, 20, 5);

    expect(pile.height(10, 20), 12);
  });

  test('clearing flattens it again', () {
    pile.raise(10, 20, 12);
    pile.clear(100);

    expect(pile.height(0, 100), 0);
  });

  test('ranges outside the area use the edge columns', () {
    pile.raise(95, 100, 7);

    expect(pile.height(120, 140), 7);
    expect(() => pile.height(-20, -10), returnsNormally);
  });
}
