import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/input_bar_actions.dart';
import 'package:lifely/src/shared/voice_input/presentation/voice_input_controller.dart';

/// Text box for messages; fills in with speech while the mic is on.
class const MessageInputBar({
  super.key,
  required final ValueChanged<String> onSend,
}) extends StatefulWidget {
  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _text = TextEditingController();
  late final EffectCleanup _stopMirroringSpeech;

  @override
  void initState() {
    super.initState();
    final voice = context.read<VoiceInputController>();
    // Mirror speech into the text box as words are heard.
    _stopMirroringSpeech = effect(() {
      final heard = voice.text.value;
      if (heard.isEmpty) return;
      _text.value = TextEditingValue(
        text: heard,
        selection: .collapsed(offset: heard.length),
      );
    });
  }

  @override
  void dispose() {
    _stopMirroringSpeech();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: Sizes.p4,
      color: context.color.surfaceContainerHigh,
      borderRadius: .circular(Sizes.p32),
      child: Padding(
        padding: const .all(Sizes.p8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _text,
                keyboardType: .multiline,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: context.loc.aiInputHint,
                  border: InputBorder.none,
                  contentPadding: const .symmetric(horizontal: Sizes.p16),
                ),
              ),
            ),
            InputBarActions(text: _text, onSend: _send),
          ],
        ),
      ),
    );
  }

  void _send() {
    final message = _text.text.trim();
    if (message.isEmpty) return;
    _text.clear();
    widget.onSend(message);
  }
}
