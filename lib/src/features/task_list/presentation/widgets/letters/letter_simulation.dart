import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_particle.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_pile.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_sheet.dart';

/// Moves flying letters with simple physics. Fallen letters pile up on the
/// floor, like sand: a letter on a steep edge slides down to the lower side,
/// and a letter falls again when the letters under it fade away.
class LetterSimulation(final Random _random) {
  static const _overlap = 0.8;
  static const _bounce = 0.4;

  /// Sliding speed down a steep pile edge, in letter widths per second.
  static const _slide = 12.0;

  /// How close (in pixels) a letter must be to what's under it to rest on it.
  static const _touch = 0.5;

  final particles = <LetterParticle>[];
  final _pile = LetterPile();

  bool get isIdle => particles.isEmpty;

  void add(Letter letter, LetterSheet sheet, Rect spot, LetterMotion motion) {
    particles.add(LetterParticle.launch(letter, sheet, spot, motion, _random));
  }

  /// Moves every letter forward by [dt] seconds inside an area of [size].
  void step(double dt, Size size) {
    _buildPile(size);
    for (final p in particles) {
      p.age += dt;
      if (p.landed) continue;
      final lastY = p.position.dy;
      p.velocity += Offset(0, _gravity(p.motion) * dt);
      p.position += p.velocity * dt;
      p.angle += p.spin * dt;
      if (p.motion == .fall) _collide(p, size, lastY);
    }
    particles.removeWhere((p) {
      if (p.isGone) p.sheet.release();
      return p.isGone;
    });
  }

  void dispose() {
    for (final p in particles) {
      p.sheet.release();
    }
    particles.clear();
  }

  double _gravity(LetterMotion motion) => switch (motion) {
    .fall => 2000,
    .rise => -700,
    .blowAway => 300,
  };

  /// Stacks the resting letters from the bottom up. A letter with nothing
  /// left under it (its support faded away) starts falling again.
  void _buildPile(Size size) {
    _pile.clear(size.width);
    final resting = [
      for (final p in particles)
        if (p.landed) p,
    ]..sort((a, b) => b.position.dy.compareTo(a.position.dy));
    for (final p in resting) {
      final half = p.size.width / 2;
      final x = p.position.dx;
      final floor = size.height - _pile.height(x - half, x + half);
      if (p.position.dy + _reach(p) < floor - _touch) {
        p.landed = false;
        continue;
      }
      _pile.raise(x - half, x + half, size.height - p.position.dy + _reach(p));
    }
  }

  /// [lastY] is where [p] was before this step, so a fast letter can't skip
  /// past the letters it should land on.
  void _collide(LetterParticle p, Size size, double lastY) {
    final half = p.size.width / 2;
    if (p.position.dx < half || p.position.dx > size.width - half) {
      final x = p.position.dx
          .clamp(half, max(half, size.width - half))
          .toDouble();
      p.position = Offset(x, p.position.dy);
      p.velocity = Offset(-p.velocity.dx * _bounce, p.velocity.dy);
    }
    final x = p.position.dx;
    final reach = _reach(p);
    var ground = _pile.height(x - half, x + half);
    // Started under the pile's top (below an overhang): only the floor counts.
    if (lastY + reach > size.height - ground + _touch) ground = 0;
    final floor = size.height - ground;
    if (p.position.dy + reach < floor) return;

    // Walls count as high ground, so letters never slide into them.
    final left = x < 2 * half
        ? double.infinity
        : _pile.height(x - 3 * half, x - half);
    final right = x > size.width - 2 * half
        ? double.infinity
        : _pile.height(x + half, x + 3 * half);
    p.position = Offset(x, floor - reach);
    if (ground - min(left, right) > p.size.height / 2) {
      // Too steep here: slide toward the lower side and keep falling.
      final side = left < right ? -1 : 1;
      p.velocity = Offset(side * p.size.width * _slide, 0);
      return;
    }
    p.velocity = .zero;
    p.landed = true;
    _pile.raise(x - half, x + half, ground + 2 * reach);
  }

  /// How far below its center a letter touches what it rests on. Letters
  /// overlap a little so the pile looks packed.
  double _reach(LetterParticle p) => p.size.height * _overlap / 2;
}
