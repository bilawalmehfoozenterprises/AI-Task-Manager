import 'package:firebase_ai/firebase_ai.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/ai_assistant/data/ai_prompt_builder.dart';
import 'package:lifely/src/features/ai_assistant/data/ai_reply_decoder.dart';
import 'package:lifely/src/features/ai_assistant/data/ai_repository.dart';
import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';

/// [AiRepository] backed by Gemini through Firebase AI Logic.
class GeminiAiRepository(
  final GenerativeModel _model,
  final Logger _logger, {
  final AiPromptBuilder _promptBuilder = const AiPromptBuilder(),
}) implements AiRepository {
  @override
  Future<AiReply> ask({
    required String message,
    required List<ChatMessage> history,
  }) async {
    final prompt = _promptBuilder.build(
      message: message,
      history: history,
      today: DateTime.now(),
    );
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      _logger.info('Gemini reply: $text');
      if (text == null) return const AiFailure(.invalidReply);
      return decodeAiReply(text);
    } on FormatException catch (error) {
      _logger.warning('Gemini reply was not valid JSON: $error');
      return const AiFailure(.invalidReply);
    } catch (error, stackTrace) {
      _logger.severe(
        'Gemini request failed',
        error: error,
        stackTrace: stackTrace,
      );
      return AiFailure(_reasonFor(error));
    }
  }

  /// Overload and quota errors are temporary; anything else means the AI
  /// can't be used right now.
  AiFailureReason _reasonFor(Object error) {
    final isBusy = switch (error) {
      QuotaExceeded() || ServerException() => true,
      FirebaseAIException(:final message) => message.startsWith(
        'Server Error [5',
      ),
      _ => false,
    };
    return isBusy ? .busy : .unavailable;
  }
}
