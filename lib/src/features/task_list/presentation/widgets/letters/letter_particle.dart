import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_sheet.dart';

/// One flying letter: where it is, how it moves, and how visible it is.
class LetterParticle({
  required final LetterSheet sheet,
  required final Rect spot,
  required final LetterMotion motion,
  required var Offset position,
  required var Offset velocity,
  required final double spin,
}) {
  /// Seconds a fallen letter rests on the pile before it starts fading.
  static const pileRest = 2.5;
  static const _fallFade = 0.5;
  static const _riseLife = 1.6;
  static const _blowLife = 1.0;

  /// Rotation in radians.
  double angle = 0;

  /// Seconds since the letter was launched.
  double age = 0;

  /// True once the letter rests on the pile.
  bool landed = false;

  /// Starts [letter] moving the way [motion] asks, with a little randomness.
  factory LetterParticle.launch(
    Letter letter,
    LetterSheet sheet,
    Rect spot,
    LetterMotion motion,
    Random random,
  ) {
    double between(double a, double b) => a + random.nextDouble() * (b - a);
    final velocity = switch (motion) {
      .fall => Offset(between(-80, 80), between(-220, -40)),
      .rise => Offset(between(-40, 40), between(-60, 0)),
      .blowAway => Offset(between(-1100, -500), between(-300, -80)),
    };
    final spin = switch (motion) {
      .fall => between(-4, 4),
      .rise => between(-1, 1),
      .blowAway => between(-9, -3),
    };
    return LetterParticle(
      sheet: sheet,
      spot: spot,
      motion: motion,
      position: letter.rect.center,
      velocity: velocity,
      spin: spin,
    );
  }

  /// Size on screen; [spot] is the letter's place on [sheet], in pixels.
  Size get size => spot.size / sheet.pixelRatio;

  /// 1 is fully visible, 0 is gone.
  double get opacity {
    final left = switch (motion) {
      .fall => (pileRest + _fallFade - age) / _fallFade,
      .rise => 1 - age / _riseLife,
      .blowAway => 1 - age / _blowLife,
    };
    return left.clamp(0.0, 1.0);
  }

  bool get isGone => opacity == 0;
}
