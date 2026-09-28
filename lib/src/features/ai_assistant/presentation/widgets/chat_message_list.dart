import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/layout/window_size_class.dart';
import 'package:lifely/src/features/ai_assistant/presentation/controller/ai_chat_controller.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/message_bubble.dart';

/// All chat messages, newest at the bottom.
class const ChatMessageList({super.key}) extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final messages = context.read<AiChatController>().messages.value;
    return ListView.builder(
      reverse: true,
      padding: .all(context.windowSizeClass.margin),
      itemCount: messages.length,
      itemBuilder: (context, index) =>
          MessageBubble(message: messages[messages.length - 1 - index]),
    );
  }
}
