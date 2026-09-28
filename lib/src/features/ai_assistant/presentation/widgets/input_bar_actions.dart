import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/features/ai_assistant/presentation/controller/ai_chat_controller.dart';
import 'package:lifely/src/shared/voice_input/domain/voice_input_status.dart';
import 'package:lifely/src/shared/voice_input/presentation/mic_button.dart';
import 'package:lifely/src/shared/voice_input/presentation/voice_input_controller.dart';

/// A spinner while the AI works; otherwise the mic, plus Send when there's text.
class const InputBarActions({
  super.key,
  required final TextEditingController text,
  required final VoidCallback onSend,
}) extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final isThinking = context.read<AiChatController>().isThinking.value;
    final isListening =
        context.read<VoiceInputController>().status.value ==
        VoiceInputStatus.listening;
    if (isThinking) {
      return const IconButton(
        onPressed: null,
        icon: SizedBox.square(
          dimension: Sizes.p24,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ValueListenableBuilder(
      valueListenable: text,
      builder: (context, value, _) => Row(
        mainAxisSize: .min,
        children: [
          MicButton(typedText: () => text.text),
          if (value.text.trim().isNotEmpty)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: isListening ? null : onSend,
            ),
        ],
      ),
    );
  }
}
