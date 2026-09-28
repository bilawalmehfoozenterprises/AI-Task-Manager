import 'dart:math';
import 'dart:typed_data';

/// Height of the letter pile, kept per narrow column of the screen, so
/// finding the pile under a letter only reads a few numbers.
class LetterPile {
  /// Width in pixels of one column.
  static const _column = 2.0;

  var _tops = Float64List(0);

  /// Empties the pile for an area [width] pixels wide.
  void clear(double width) {
    final count = (width / _column).ceil() + 1;
    if (_tops.length == count) {
      _tops.fillRange(0, count, 0);
    } else {
      _tops = Float64List(count);
    }
  }

  /// Highest point between [from] and [to], measured up from the floor.
  double height(double from, double to) {
    var top = 0.0;
    for (var c = _index(from); c <= _index(to); c++) {
      top = max(top, _tops[c]);
    }
    return top;
  }

  /// Raises the pile between [from] and [to] to at least [top].
  void raise(double from, double to, double top) {
    for (var c = _index(from); c <= _index(to); c++) {
      _tops[c] = max(_tops[c], top);
    }
  }

  int _index(double x) => (x / _column).floor().clamp(0, _tops.length - 1);
}
