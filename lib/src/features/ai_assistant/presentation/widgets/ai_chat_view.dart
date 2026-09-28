import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/ai_assistant/presentation/controller/ai_chat_controller.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/chat_message_list.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/message_input_bar.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/task_confirmation_dialog.dart';

/// The chat page. After a message, asks to confirm any drafted task and
/// closes once it's saved.
class const AiChatView({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.aiAssistantTitle)),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: ChatMessageList()),
            MessageInputBar(onSend: (text) => _send(context, text)),
          ],
        ),
      ),
    );
  }

  Future<void> _send(BuildContext context, String text) async {
    final chat = context.read<AiChatController>();
    final draft = await chat.send(text);
    if (draft == null || !context.mounted) return;
    final confirmed = await showTaskConfirmationDialog(
      context: context,
      draft: draft,
    );
    if (confirmed != true) return;
    final saved = await chat.saveDraft(draft);
    if (saved && context.mounted) context.pop();
  }
}
