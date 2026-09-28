import 'package:equatable/equatable.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';

enum AiFailureReason { busy, unavailable, invalidReply }

/// What the AI answered.
sealed class const AiReply() extends Equatable {
  /// Reads the JSON reply described in the task-extraction prompt.
  factory fromJson(Map<String, Object?> json) {
    const invalid = AiFailure(.invalidReply);
    switch (json['status']) {
      case 'task_ready':
        final task = json['task'];
        final draft = task is Map<String, Object?>
            ? TaskDraft.fromJson(task)
            : null;
        return draft == null ? invalid : AiTaskReady(draft);
      case 'clarification_needed':
        final question = json['question'];
        return question is String && question.isNotEmpty
            ? AiClarification(question)
            : invalid;
      case 'error':
        final message = json['message'];
        return message is String && message.isNotEmpty
            ? AiClarification(message)
            : invalid;
      default:
        return invalid;
    }
  }

  @override
  List<Object?> get props => [];
}

/// The AI needs more details, or explains why it can't help.
class const AiClarification(final String question) extends AiReply {
  @override
  List<Object?> get props => [question];
}

class const AiTaskReady(final TaskDraft draft) extends AiReply {
  @override
  List<Object?> get props => [draft];
}

class const AiFailure(final AiFailureReason reason) extends AiReply {
  @override
  List<Object?> get props => [reason];
}
