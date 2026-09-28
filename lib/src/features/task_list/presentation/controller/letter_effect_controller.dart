import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letters/letter_burst.dart';

/// Passes letter bursts from task rows to the letter layer that draws them.
class LetterEffectController {
  final _waiting = <LetterBurst>[];

  /// Goes up by one each time a burst is waiting to be played.
  final requests = signal(0);

  void play(LetterBurst burst) {
    _waiting.add(burst);
    requests.value++;
  }

  /// Hands over the waiting bursts and empties the queue.
  List<LetterBurst> takeAll() {
    final all = List.of(_waiting);
    _waiting.clear();
    return all;
  }

  void dispose() => requests.dispose();
}
