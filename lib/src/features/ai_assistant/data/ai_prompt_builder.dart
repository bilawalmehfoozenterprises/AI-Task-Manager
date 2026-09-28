import 'package:intl/intl.dart';
import 'package:lifely/src/features/ai_assistant/data/ai_prompt.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';

/// Fills the prompt template with today's date, the chat so far, and the
/// new message.
class const AiPromptBuilder() {
  String build({
    required String message,
    required List<ChatMessage> history,
    required DateTime today,
  }) {
    final lines = [
      for (final entry in history)
        if (entry.text case final text?) '${entry.sender.name}: $text',
    ];
    return kTaskExtractionPrompt
        .replaceAll('{TODAY_DATE}', DateFormat('yyyy-MM-dd').format(today))
        .replaceAll('{HISTORY}', lines.join('\n'))
        .replaceAll('{USER_MESSAGE}', message);
  }
}
