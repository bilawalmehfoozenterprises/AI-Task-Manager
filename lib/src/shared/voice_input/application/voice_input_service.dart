import 'package:lifely/src/shared/voice_input/data/mic_permission_repository.dart';
import 'package:lifely/src/shared/voice_input/data/speech_repository.dart';
import 'package:lifely/src/shared/voice_input/domain/voice_input_status.dart';

/// Gets permission, then starts and stops speech recognition.
class VoiceInputService(
  final MicPermissionRepository _permission,
  final SpeechRepository _speech,
) {
  Stream<VoiceInputStatus> get statusChanges => _speech.statusChanges;
  Stream<String> get recognizedWords => _speech.recognizedWords;

  /// Returns true when voice input can be used.
  Future<bool> prepare() async {
    final granted = await _permission.request();
    if (!granted) return false;
    return _speech.initialize();
  }

  Future<void> start() => _speech.startListening();

  Future<void> stop() => _speech.stopListening();
}
