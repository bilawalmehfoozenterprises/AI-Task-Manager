import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

enum SpeechRecognitionStatus {
  notAvailable,
  available,
  listening,
  stopped,
  error,
}

class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _isDisposed = false;

  String _lastError = '';
  String get lastError => _lastError;

  final ValueNotifier<String> _recognizedWordsNotifier = ValueNotifier('');
  ValueNotifier<String> get recognizedWordsNotifier => _recognizedWordsNotifier;

  final ValueNotifier<SpeechRecognitionStatus> _statusNotifier = ValueNotifier(
    SpeechRecognitionStatus.notAvailable,
  );
  ValueNotifier<SpeechRecognitionStatus> get statusNotifier => _statusNotifier;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      _statusNotifier.value = SpeechRecognitionStatus.notAvailable;
      return;
    }

    _isInitialized = await _speechToText.initialize(
      onError: (error) {
        if (_isDisposed) return;
        _lastError = error.errorMsg;
        _statusNotifier.value = SpeechRecognitionStatus.error;
      },
      onStatus: (status) {
        if (_isDisposed) return;
        switch (status) {
          case 'listening':
            _statusNotifier.value = SpeechRecognitionStatus.listening;
            break;
          case 'notListening':
            _statusNotifier.value = SpeechRecognitionStatus.stopped;
            break;
          case 'done':
            _statusNotifier.value = SpeechRecognitionStatus.available;
            break;
          default:
            _statusNotifier.value = SpeechRecognitionStatus.notAvailable;
            break;
        }
      },
    );

    if (_isInitialized) {
      _statusNotifier.value = SpeechRecognitionStatus.available;
    } else {
      _statusNotifier.value = SpeechRecognitionStatus.notAvailable;
    }
  }

  Future<bool> _requestPermissions() async {
    final microphoneStatus = await Permission.microphone.request();
    final speechStatus = await Permission.speech.request();

    return microphoneStatus.isGranted && speechStatus.isGranted;
  }

  void startListening({String prefix = ''}) {
    if (!_isInitialized || _speechToText.isListening) return;

    _recognizedWordsNotifier.value = prefix; // Initialize with prefix
    _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        if (_isDisposed) return;
        // Append to prefix
        _recognizedWordsNotifier.value =
            prefix +
            (prefix.isNotEmpty && result.recognizedWords.isNotEmpty
                ? ' '
                : '') +
            result.recognizedWords;
        if (result.finalResult) {
          _statusNotifier.value = SpeechRecognitionStatus.stopped;
        }
      },
    );
    _statusNotifier.value = SpeechRecognitionStatus.listening;
  }

  void stopListening() {
    if (_speechToText.isListening) {
      _speechToText.stop();
      _statusNotifier.value = SpeechRecognitionStatus.stopped;
    }
  }

  void cancelListening() {
    if (_speechToText.isListening) {
      _speechToText.cancel();
      _statusNotifier.value = SpeechRecognitionStatus.stopped;
    }
  }

  void dispose() {
    _isDisposed = true;
    _speechToText.cancel();
    _recognizedWordsNotifier.dispose();
    _statusNotifier.dispose();
  }
}
