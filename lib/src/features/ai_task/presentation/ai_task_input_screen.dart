import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/src/features/ai_task/application/ai_service.dart';
import 'package:todo_app/src/features/ai_task/application/speech_recognition_service.dart';
import 'package:todo_app/src/features/ai_task/presentation/cubit/speech_recognition_cubit.dart';
import 'package:todo_app/src/features/ai_task/presentation/cubit/ai_task_cubit.dart';
import 'package:todo_app/src/features/ai_task/presentation/cubit/ai_task_state.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/src/utils/extensions.dart';
import 'package:todo_app/src/common/alert_dialogues.dart';
import 'package:todo_app/src/features/ai_task/presentation/widgets/message_bubble.dart';
import 'package:todo_app/src/features/ai_task/presentation/widgets/message_input_bar.dart';
import 'package:todo_app/src/features/ai_task/presentation/widgets/task_confirmation_dialog.dart';

class AiTaskInputScreen extends StatelessWidget {
  const AiTaskInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SpeechRecognitionService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SpeechRecognitionCubit(
              context.read<SpeechRecognitionService>(),
            ),
          ),
          BlocProvider(
            create: (context) => AiTaskCubit(
              GetIt.instance<AiService>(),
              context.read<TodoCubit>(),
            ),
          ),
        ],
        child: const _AiTaskInputView(),
      ),
    );
  }
}

class _AiTaskInputView extends StatefulWidget {
  const _AiTaskInputView();

  @override
  State<_AiTaskInputView> createState() => _AiTaskInputViewState();
}

class _AiTaskInputViewState extends State<_AiTaskInputView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.aiTaskInputTitle)),
      body: SafeArea(
        child: BlocConsumer<AiTaskCubit, AiTaskState>(
          listener: (context, state) {
            if (state.status == AiStateStatus.saved) {
              Navigator.of(context).pop();
            } else if (state.status == AiStateStatus.error &&
                state.errorMessage != null) {
              showExceptionAlertDialog(
                context: context,
                title: context.loc.error,
                exception: state.errorMessage!,
              );
            } else if (state.status == AiStateStatus.readyForConfirmation &&
                state.taskDraft != null) {
              showTaskConfirmationDialog(
                context: context,
                draft: state.taskDraft!,
              ).then((confirmed) {
                if (confirmed == true) {
                  if (!context.mounted) return;
                  context.read<AiTaskCubit>().confirmTask(state.taskDraft!);
                } else {
                  // User cancelled
                  if (!context.mounted) return;
                  context.read<AiTaskCubit>().clearTaskDraft();
                }
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          state.messages[state.messages.length - 1 - index];
                      return MessageBubble(message: message);
                    },
                  ),
                ),
                MessageInputBar(
                  onSend: (text) {
                    context.read<AiTaskCubit>().processUserMessage(text);
                  },
                  isLoading: state.status == AiStateStatus.loading,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
