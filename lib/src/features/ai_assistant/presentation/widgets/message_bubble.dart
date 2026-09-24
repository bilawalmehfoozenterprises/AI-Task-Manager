import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/chat_notice_text.dart';

/// One chat bubble: user messages on the right, assistant on the left.
class const MessageBubble({super.key, required final ChatMessage message})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == .user;
    final text = message.text ?? message.notice?.message(context.loc) ?? '';
    return Align(
      alignment: isUser ? .centerRight : .centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
        ),
        padding: const .all(Sizes.p12),
        margin: const .symmetric(vertical: Sizes.p4),
        decoration: BoxDecoration(
          color: isUser ? context.color.primary : context.color.secondary,
          borderRadius: .circular(Sizes.p16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? context.color.onPrimary : context.color.onSecondary,
          ),
        ),
      ),
    );
  }
}
