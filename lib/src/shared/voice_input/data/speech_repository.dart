import 'package:lifely/src/shared/voice_input/domain/voice_input_status.dart';

/// Turns speech into text.
abstract class SpeechRepository {
  /// Emits [VoiceInputStatus.listening] or [VoiceInputStatus.ready].
  Stream<VoiceInputStatus> get statusChanges;

  /// Emits the words heard so far in the current listening session.
  Stream<String> get recognizedWords;

  /// Returns false when speech recognition isn't available on this device.
  Future<bool> initialize();

  Future<void> startListening();

  Future<void> stopListening();

  /// Stops listening and frees resources.
  Future<void> dispose();
}
