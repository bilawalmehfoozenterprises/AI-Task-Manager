import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/features/ai_task/presentation/cubit/speech_recognition_cubit.dart';
import 'package:todo_app/src/utils/extensions.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({
    super.key,
    required this.onSend,
    required this.isLoading,
  });

  final Function(String) onSend;
  final bool isLoading;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    context.read<SpeechRecognitionCubit>().initialize();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _canSend = _controller.text.isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_canSend) {
      widget.onSend(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpeechRecognitionCubit, SpeechRecognitionState>(
      listener: (context, state) {
        // Only speech results change the text; errors keep what was typed.
        final String text;
        if (state is SpeechRecognitionListening) {
          text = state.recognizedWords;
        } else if (state is SpeechRecognitionAvailable) {
          text = state.recognizedWords;
        } else {
          return;
        }

        if (_controller.text != text) {
          _controller.text = text;
          // Move cursor to the end
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
      },
      child: Material(
        elevation: Sizes.p4,
        child: Container(
          padding: const EdgeInsets.all(Sizes.p8),
          decoration: BoxDecoration(
            color: context.color.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(Sizes.p32),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: context.loc.aiInputHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p16,
                    ),
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              BlocBuilder<SpeechRecognitionCubit, SpeechRecognitionState>(
                builder: (context, state) {
                  if (widget.isLoading) {
                    return const IconButton(
                      icon: SizedBox(
                        width: Sizes.p24,
                        height: Sizes.p24,
                        child: CircularProgressIndicator(),
                      ),
                      onPressed: null,
                    );
                  }

                  if (state is SpeechRecognitionListening) {
                    return IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () => context
                          .read<SpeechRecognitionCubit>()
                          .stopListening(),
                    );
                  }

                  // If not listening and not loading
                  // Check if there's text in the controller
                  final bool hasText = _controller.text.isNotEmpty;

                  if (hasText) {
                    // Show Mic and Send buttons
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () => context
                              .read<SpeechRecognitionCubit>()
                              .startListening(currentText: _controller.text),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: state is SpeechRecognitionListening
                              ? null
                              : _handleSend,
                        ),
                      ],
                    );
                  } else {
                    // Show only Mic button
                    return IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () => context
                          .read<SpeechRecognitionCubit>()
                          .startListening(currentText: _controller.text),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
