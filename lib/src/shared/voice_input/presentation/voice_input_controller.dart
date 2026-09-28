import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/shared/voice_input/application/voice_input_service.dart';
import 'package:lifely/src/shared/voice_input/domain/voice_input_status.dart';

/// Tracks listening and adds heard words after any text already typed.
class VoiceInputController {
  VoiceInputController(this._service) {
    _subscriptions = [
      _service.statusChanges.listen(_onStatus),
      _service.recognizedWords.listen(_onWords),
    ];
    _prepare();
  }

  final VoiceInputService _service;
  late final List<StreamSubscription<Object?>> _subscriptions;
  String _typedText = '';
  bool _isDisposed = false;

  final status = signal(VoiceInputStatus.preparing);

  /// Text typed before listening started, plus the words heard since.
  final text = signal('');

  /// Starts listening; heard words are added after [typedText].
  Future<void> start({required String typedText}) {
    _typedText = typedText.trim();
    text.value = _typedText;
    return _service.start();
  }

  Future<void> stop() => _service.stop();

  void dispose() {
    _isDisposed = true;
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _service.stop();
    status.dispose();
    text.dispose();
  }

  Future<void> _prepare() async {
    final available = await _service.prepare();
    if (_isDisposed) return;
    status.value = available
        ? VoiceInputStatus.ready
        : VoiceInputStatus.unavailable;
  }

  void _onStatus(VoiceInputStatus newStatus) {
    if (status.value != VoiceInputStatus.unavailable) status.value = newStatus;
  }

  void _onWords(String words) {
    text.value = [_typedText, words].where((part) => part.isNotEmpty).join(' ');
  }
}
