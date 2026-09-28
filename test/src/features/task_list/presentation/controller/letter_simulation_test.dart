import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_simulation.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  const area = Size(400, 800);
  const start = Offset(200, 100);
  late LetterSimulation simulation;

  setUp(() => simulation = LetterSimulation(Random(1)));
  tearDown(() => simulation.dispose());

  void addLetters(LetterMotion motion, {int count = 1}) {
    for (var i = 0; i < count; i++) {
      final glyph = TextPainter(
        text: const TextSpan(text: 'A', style: TextStyle(fontSize: 16)),
        textDirection: .ltr,
      )..layout();
      simulation.add(Letter('A', start & glyph.size), glyph, motion);
    }
  }

  /// Runs the simulation for [seconds] at 60 frames a second.
  void run(double seconds) {
    for (var t = 0.0; t < seconds; t += 1 / 60) {
      simulation.step(1 / 60, area);
    }
  }

  test('ticked letters fall and rest on the floor', () {
    addLetters(.fall);
    run(1.5);

    final letter = simulation.particles.single;
    expect(letter.landed, isTrue);
    expect(letter.position.dy, greaterThan(area.height - letter.size.height));
    expect(letter.opacity, 1);
  });

  test('fallen letters pile on top of each other', () {
    addLetters(.fall, count: 12);
    run(2);

    final tops = simulation.particles.map((p) => p.position.dy);
    expect(simulation.particles.every((p) => p.landed), isTrue);
    expect(tops.reduce(min), lessThan(area.height - 20));
  });

  test('ticked letters fade away after resting on the pile', () {
    addLetters(.fall);
    run(3.2);

    expect(simulation.isIdle, isTrue);
  });

  test('unticked letters float up and fade', () {
    addLetters(.rise);
    run(0.5);
    final letter = simulation.particles.single;
    expect(letter.position.dy, lessThan(start.dy));
    expect(letter.opacity, lessThan(1));

    run(1.5);
    expect(simulation.isIdle, isTrue);
  });

  test('deleted letters blow away to the left', () {
    addLetters(.blowAway);
    run(0.3);
    expect(simulation.particles.single.position.dx, lessThan(start.dx));

    run(1);
    expect(simulation.isIdle, isTrue);
  });
}
