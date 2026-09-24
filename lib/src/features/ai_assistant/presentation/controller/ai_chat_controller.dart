import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/ai_assistant/application/ai_assistant_service.dart';
import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';

/// Runs the chat: sends messages, shows replies, saves confirmed drafts.
class AiChatController(
  final AiAssistantService _service,
  final Logger _logger,
) {
  final messages = signal(const <ChatMessage>[]);

  /// True while waiting for the AI or saving a task.
  final isThinking = signal(false);

  /// Sends [text]. Returns a draft when the AI suggests a task to confirm.
  Future<TaskDraft?> send(String text) async {
    final history = messages.value;
    _add(ChatMessage.user(text));
    isThinking.value = true;
    final reply = await _service.ask(message: text, history: history);
    isThinking.value = false;
    switch (reply) {
      case AiClarification(:final question):
        _add(ChatMessage.assistant(question));
      case AiTaskReady(:final draft):
        _add(const ChatMessage.notice(.draftReady));
        return draft;
      case AiFailure(:final reason):
        _add(ChatMessage.notice(_noticeFor(reason)));
    }
    return null;
  }

  /// Saves a confirmed draft. Returns true when it was saved.
  Future<bool> saveDraft(TaskDraft draft) async {
    isThinking.value = true;
    try {
      await _service.saveDraft(draft);
      _add(const ChatMessage.notice(.taskSaved));
      return true;
    } catch (error, stackTrace) {
      _logger.severe(
        'Failed to save AI task',
        error: error,
        stackTrace: stackTrace,
      );
      _add(const ChatMessage.notice(.saveFailed));
      return false;
    } finally {
      isThinking.value = false;
    }
  }

  void dispose() {
    messages.dispose();
    isThinking.dispose();
  }

  void _add(ChatMessage message) =>
      messages.value = [...messages.value, message];

  ChatNotice _noticeFor(AiFailureReason reason) => switch (reason) {
    .busy => .busy,
    .unavailable => .unavailable,
    .invalidReply => .invalidReply,
  };
}
