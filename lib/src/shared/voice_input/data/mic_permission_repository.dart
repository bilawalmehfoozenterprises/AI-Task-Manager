import 'package:permission_handler/permission_handler.dart';

/// Asks the OS for the permissions voice input needs.
class MicPermissionRepository {
  /// Returns true when both microphone and speech access are granted.
  Future<bool> request() async {
    final microphone = await Permission.microphone.request();
    final speech = await Permission.speech.request();
    return microphone.isGranted && speech.isGranted;
  }
}
