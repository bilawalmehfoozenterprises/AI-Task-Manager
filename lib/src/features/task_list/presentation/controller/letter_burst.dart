import 'package:material_ui/material_ui.dart';

/// How a task title's letters move.
enum LetterMotion {
  /// Task ticked: letters drop, pile up at the bottom, then fade.
  fall,

  /// Task unticked: letters float up and fade.
  rise,

  /// Task deleted: letters blow away to the left.
  blowAway,
}

/// One character of a task title and where it sits on screen.
class const Letter(final String char, final Rect rect);

/// A task title broken into letters, ready to animate.
class const LetterBurst({
  required final List<Letter> letters,
  required final TextStyle style,
  required final TextScaler textScaler,
  required final LetterMotion motion,
});
