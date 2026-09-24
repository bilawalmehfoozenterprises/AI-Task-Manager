import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/features/ai_task/application/ai_service.dart';
import 'package:todo_app/src/features/ai_task/domain/ai_task_draft.dart';
import 'package:todo_app/src/features/ai_task/domain/ai_task_response.dart';
import 'package:todo_app/src/features/ai_task/domain/chat_message.dart';
import 'package:todo_app/src/features/ai_task/presentation/cubit/ai_task_state.dart';
import 'package:todo_app/src/features/todo_list/domain/todo_model.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/src/localization/string_hardcoded.dart';

class AiTaskCubit extends Cubit<AiTaskState> {
  final AiService _aiService;
  final TodoCubit _todoCubit;

  AiTaskCubit(this._aiService, this._todoCubit) : super(const AiTaskState());

  // Handles user input
  Future<void> processUserMessage(String message) async {
    _addMessage(text: message, sender: Sender.user);
    emit(state.copyWith(status: AiStateStatus.loading));

    try {
      final response = await _askAiWithHistory(message);
      _handleAiResponse(response);
    } catch (e) {
      emit(
        state.copyWith(status: AiStateStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // Confirms and saves AI-created task
  Future<void> confirmTask(AiTaskDraft draft) async {
    emit(state.copyWith(status: AiStateStatus.loading));
    try {
      final todo = Todo(
        id: -1,
        name: draft.title,
        description: draft.description,
        deadline: draft.deadline,
        isCompleted: false,
      );
      final saved = await _todoCubit.addTodo(todo);
      if (!saved) {
        emit(
          state.copyWith(
            status: AiStateStatus.error,
            errorMessage: 'Failed to save the task.'.hardcoded,
          ),
        );
        return;
      }
      emit(state.copyWith(status: AiStateStatus.saved));
    } catch (e) {
      emit(
        state.copyWith(status: AiStateStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // Resets to initial state
  void resetState() => emit(const AiTaskState());

  // Clears the task draft from the state
  void clearTaskDraft() {
    emit(AiTaskState(messages: state.messages, status: AiStateStatus.success));
  }

  // -----------------Helpers-----------------

  // Adds a message to the conversation safely
  void _addMessage({required String text, required Sender sender}) {
    final message = ChatMessage(text: text, sender: sender);
    final updated = List<ChatMessage>.from(state.messages)..add(message);
    emit(state.copyWith(messages: updated));
  }

  // Handles communication with AI service
  Future<AiTaskResponse> _askAiWithHistory(String message) {
    return _aiService.askAi(
      message,
      conversationHistory: _buildConversationHistory(),
    );
  }

  // Handles all AI response types
  void _handleAiResponse(AiTaskResponse response) {
    switch (response.status) {
      case AiTaskResponseStatus.clarificationNeeded:
        _addMessage(
          text: response.clarificationQuestion ?? "Can you clarify?",
          sender: Sender.ai,
        );
        emit(state.copyWith(status: AiStateStatus.success));
        break;

      case AiTaskResponseStatus.taskReady:
        _addMessage(
          text: "I’ve drafted a task. Please confirm to save it.",
          sender: Sender.ai,
        );
        emit(
          state.copyWith(
            status: AiStateStatus.readyForConfirmation,
            taskDraft: response.taskDraft,
          ),
        );
        break;

      case AiTaskResponseStatus.error:
        _addMessage(
          text: response.errorMessage ?? "Something went wrong.",
          sender: Sender.ai,
        );
        emit(
          state.copyWith(
            status: AiStateStatus.error,
            errorMessage: response.errorMessage,
          ),
        );
        break;
    }
  }

  // Converts messages into AI conversation format
  List<Map<String, String>> _buildConversationHistory() {
    return state.messages
        .map(
          (m) => {
            'role': m.sender.toString().split('.').last,
            'content': m.text,
          },
        )
        .toList();
  }
}
