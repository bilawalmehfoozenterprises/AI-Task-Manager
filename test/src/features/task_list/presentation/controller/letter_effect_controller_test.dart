import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_effect_controller.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late LetterEffectController controller;
  const burst = LetterBurst(
    letters: [Letter('A', Rect.zero)],
    style: TextStyle(),
    textScaler: .noScaling,
    motion: .fall,
  );

  setUp(() => controller = LetterEffectController());
  tearDown(() => controller.dispose());

  test('playing a burst signals the layer and queues the burst', () {
    controller.play(burst);

    expect(controller.requests.value, 1);
    expect(controller.takeAll(), [burst]);
  });

  test('taking the bursts empties the queue', () {
    controller.play(burst);
    controller.takeAll();

    expect(controller.takeAll(), isEmpty);
  });
}
