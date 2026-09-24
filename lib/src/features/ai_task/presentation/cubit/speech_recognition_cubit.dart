import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/src/features/ai_task/application/speech_recognition_service.dart';

part 'speech_recognition_state.dart';

class SpeechRecognitionCubit extends Cubit<SpeechRecognitionState> {
  final SpeechRecognitionService _speechRecognitionService;

  SpeechRecognitionCubit(this._speechRecognitionService)
    : super(SpeechRecognitionInitial()) {
    _speechRecognitionService.statusNotifier.addListener(_onStatusChanged);
    _speechRecognitionService.recognizedWordsNotifier.addListener(
      _onWordsChanged,
    );
  }

  Future<void> initialize() async {
    emit(SpeechRecognitionLoading());
    await _speechRecognitionService.initialize();
  }

  void startListening({String currentText = ''}) {
    _speechRecognitionService.startListening(prefix: currentText);
  }

  void stopListening() {
    _speechRecognitionService.stopListening();
  }

  void _onStatusChanged() {
    final status = _speechRecognitionService.statusNotifier.value;
    final words = _speechRecognitionService.recognizedWordsNotifier.value;

    switch (status) {
      case SpeechRecognitionStatus.available:
      case SpeechRecognitionStatus.stopped:
        emit(SpeechRecognitionAvailable(recognizedWords: words));
        break;
      case SpeechRecognitionStatus.listening:
        emit(SpeechRecognitionListening(recognizedWords: words));
        break;
      case SpeechRecognitionStatus.error:
        emit(
          SpeechRecognitionError(message: _speechRecognitionService.lastError),
        );
        break;
      case SpeechRecognitionStatus.notAvailable:
        emit(
          const SpeechRecognitionError(
            message: 'Speech recognition not available.',
          ),
        );
        break;
    }
  }

  void _onWordsChanged() {
    final recognizedWords =
        _speechRecognitionService.recognizedWordsNotifier.value;
    if (state is SpeechRecognitionListening) {
      emit(SpeechRecognitionListening(recognizedWords: recognizedWords));
    } else if (state is SpeechRecognitionAvailable) {
      // This allows the final result to update the state even after listening stops
      emit(SpeechRecognitionAvailable(recognizedWords: recognizedWords));
    }
  }

  @override
  Future<void> close() {
    _speechRecognitionService.statusNotifier.removeListener(_onStatusChanged);
    _speechRecognitionService.recognizedWordsNotifier.removeListener(
      _onWordsChanged,
    );
    _speechRecognitionService.dispose();
    return super.close();
  }
}
