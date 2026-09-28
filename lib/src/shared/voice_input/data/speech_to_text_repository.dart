import 'dart:async';

import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/shared/voice_input/data/speech_repository.dart';
import 'package:lifely/src/shared/voice_input/domain/voice_input_status.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// [SpeechRepository] using the device's speech recognizer.
class SpeechToTextRepository(final Logger _logger) implements SpeechRepository {
  final _speech = SpeechToText();
  final _status = StreamController<VoiceInputStatus>.broadcast();
  final _words = StreamController<String>.broadcast();
  bool _isInitialized = false;

  @override
  Stream<VoiceInputStatus> get statusChanges => _status.stream;

  @override
  Stream<String> get recognizedWords => _words.stream;

  @override
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onStatus: (status) => _emitStatus(
        status == SpeechToText.listeningStatus ? .listening : .ready,
      ),
      // Errors like "no speech heard" just end the session; typed text stays.
      onError: (error) {
        _logger.warning('Speech recognition error: ${error.errorMsg}');
        _emitStatus(.ready);
      },
    );
    return _isInitialized;
  }

  @override
  Future<void> startListening() async {
    if (!_isInitialized || _speech.isListening) return;
    await _speech.listen(
      onResult: (result) {
        if (!_words.isClosed) _words.add(result.recognizedWords);
      },
    );
    _emitStatus(.listening);
  }

  @override
  Future<void> stopListening() async {
    if (!_speech.isListening) return;
    await _speech.stop();
    _emitStatus(.ready);
  }

  /// The speech engine can report late, after this repository is disposed.
  void _emitStatus(VoiceInputStatus status) {
    if (!_status.isClosed) _status.add(status);
  }

  @override
  Future<void> dispose() async {
    await _speech.cancel();
    await _status.close();
    await _words.close();
  }
}
