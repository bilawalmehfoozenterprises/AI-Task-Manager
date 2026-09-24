import 'package:lifely/src/features/ai_assistant/data/ai_repository.dart';
import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';
import 'package:lifely/src/features/ai_assistant/data/task_draft_repository.dart';

/// Talks to the AI and turns confirmed drafts into real tasks.
class AiAssistantService(
  final AiRepository _ai,
  final TaskDraftRepository _drafts,
) {
  /// [history] is the chat before [message].
  Future<AiReply> ask({
    required String message,
    required List<ChatMessage> history,
  }) {
    return _ai.ask(message: message, history: history);
  }

  Future<void> saveDraft(TaskDraft draft) => _drafts.saveDraft(draft);
}
