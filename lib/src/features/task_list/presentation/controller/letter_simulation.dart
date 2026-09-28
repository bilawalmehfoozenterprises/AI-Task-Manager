import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_particle.dart';

/// Moves flying letters with simple physics. Fallen letters pile up on the
/// floor, like sand: a letter on a steep edge slides down to the lower side.
class LetterSimulation(final Random _random) {
  static const _overlap = 0.8;
  static const _bounce = 0.4;

  final particles = <LetterParticle>[];

  bool get isIdle => particles.isEmpty;

  void add(Letter letter, TextPainter glyph, LetterMotion motion) {
    particles.add(LetterParticle.launch(letter, glyph, motion, _random));
  }

  /// Moves every letter forward by [dt] seconds inside an area of [size].
  void step(double dt, Size size) {
    for (final p in particles) {
      p.age += dt;
      if (p.landed) continue;
      p.velocity += Offset(0, _gravity(p.motion) * dt);
      p.position += p.velocity * dt;
      p.angle += p.spin * dt;
      if (p.motion == .fall) _collide(p, size);
    }
    particles.removeWhere((p) {
      if (p.isGone) p.glyph.dispose();
      return p.isGone;
    });
  }

  void dispose() {
    for (final p in particles) {
      p.glyph.dispose();
    }
    particles.clear();
  }

  double _gravity(LetterMotion motion) => switch (motion) {
    .fall => 2000,
    .rise => -700,
    .blowAway => 300,
  };

  void _collide(LetterParticle p, Size size) {
    final half = p.size.width / 2;
    if (p.position.dx < half || p.position.dx > size.width - half) {
      final x = p.position.dx
          .clamp(half, max(half, size.width - half))
          .toDouble();
      p.position = Offset(x, p.position.dy);
      p.velocity = Offset(-p.velocity.dx * _bounce, p.velocity.dy);
    }
    final x = p.position.dx;
    final ground = _pileHeight(size, x - half, x + half);
    final floor = size.height - ground;
    final reach = p.size.height * _overlap / 2;
    if (p.position.dy + reach < floor) return;

    // Walls count as high ground, so letters never slide into them.
    final left = x < 2 * half
        ? double.infinity
        : _pileHeight(size, x - 3 * half, x - half);
    final right = x > size.width - 2 * half
        ? double.infinity
        : _pileHeight(size, x + half, x + 3 * half);
    final lower = min(left, right);
    p.position = Offset(p.position.dx, floor - reach);
    if (ground - lower > p.size.height / 2) {
      // Too steep here: slide toward the lower side and keep falling.
      final side = left < right ? -1 : 1;
      p.velocity = Offset(side * p.size.width * 4, 0);
      return;
    }
    p.velocity = .zero;
    p.landed = true;
  }

  /// Top of the pile between [from] and [to], measured up from the floor.
  double _pileHeight(Size size, double from, double to) {
    var top = 0.0;
    for (final p in particles.where((p) => p.landed)) {
      final half = p.size.width / 2;
      if (p.position.dx + half < from || p.position.dx - half > to) continue;
      final reach = p.size.height * _overlap / 2;
      top = max(top, size.height - p.position.dy + reach);
    }
    return top;
  }
}
