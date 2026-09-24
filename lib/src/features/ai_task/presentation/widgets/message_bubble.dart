import 'package:material_ui/material_ui.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/features/ai_task/domain/chat_message.dart';
import 'package:todo_app/src/utils/extensions.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.sender == Sender.user;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
        ),
        padding: const EdgeInsets.all(Sizes.p12),
        margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
        decoration: BoxDecoration(
          color: isUserMessage
              ? context.color.primary
              : context.color.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUserMessage
                ? context.color.onPrimary
                : context.color.onSecondary,
          ),
        ),
      ),
    );
  }
}
