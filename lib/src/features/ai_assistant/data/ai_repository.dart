import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';

/// Sends a message (plus earlier chat) to the AI and returns its reply.
abstract class AiRepository {
  /// Never throws: problems come back as [AiFailure].
  Future<AiReply> ask({
    required String message,
    required List<ChatMessage> history,
  });
}
