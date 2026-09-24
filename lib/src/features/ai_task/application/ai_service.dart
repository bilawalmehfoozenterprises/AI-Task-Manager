import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:todo_app/src/features/ai_task/domain/ai_task_response.dart';
import 'package:todo_app/src/localization/string_hardcoded.dart';
import 'package:todo_app/src/utils/app_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/src/features/ai_task/domain/ai_prompts.dart';

class AiService {
  final GenerativeModel model;
  final Logger _logger = GetIt.instance<Logger>();

  AiService({required this.model});

  Future<AiTaskResponse> askAi(
    String userMessage, {
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final prompt = _buildPrompt(userMessage, conversationHistory);
      _logger.info('User Prompt: $prompt');

      final response = await model.generateContent([Content.text(prompt)]);

      final textResponse = response.text;

      if (textResponse == null) {
        return AiTaskResponse.error(
          'Gemini returned an empty response.'.hardcoded,
        );
      }
      _logger.info('Gemini Raw Response: $textResponse');

      final extractedJson = _extractResponseFromMarkdown(textResponse);
      final jsonResponse = jsonDecode(extractedJson);
      return AiTaskResponse.fromJson(jsonResponse);
    } catch (e, s) {
      _logger.severe('Error calling Gemini API', error: e, stackTrace: s);
      return AiTaskResponse.error(
        'Failed to process your request: ${e.toString()}',
      );
    }
  }

  String _buildPrompt(String userMessage, List<Map<String, String>>? history) {
    final now = DateTime.now();
    final todayDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    String historyString = '';
    if (history != null && history.isNotEmpty) {
      for (final entry in history) {
        final role = entry['role'] ?? '';
        final content = entry['content'] ?? '';
        historyString += "$role: $content\n";
      }
    }

    return kTaskExtractionPrompt
        .replaceAll('{TODAY_DATE}', todayDate)
        .replaceAll('{HISTORY_PLACEHOLDER}', historyString)
        .replaceAll('{USER_MESSAGE}', userMessage);
  }

  /// Strips a markdown code fence (``` or ```json) around the JSON, if any.
  String _extractResponseFromMarkdown(String markdown) {
    final text = markdown.trim();
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end < start) return text;
    return text.substring(start, end + 1);
  }
}
