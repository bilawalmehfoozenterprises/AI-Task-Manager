import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/features/ai_assistant/application/ai_assistant_service.dart';
import 'package:lifely/src/features/ai_assistant/data/ai_repository.dart';
import 'package:lifely/src/features/ai_assistant/data/gemini_ai_repository.dart';
import 'package:lifely/src/features/ai_assistant/data/gemini_model.dart';
import 'package:lifely/src/features/ai_assistant/data/task_draft_repository.dart';
import 'package:lifely/src/features/ai_assistant/presentation/controller/ai_chat_controller.dart';
import 'package:lifely/src/features/ai_assistant/presentation/widgets/ai_chat_view.dart';
import 'package:lifely/src/shared/voice_input/presentation/voice_input_scope.dart';

/// Chat with the AI to create tasks by typing or speaking.
/// The AI model and speech engine exist only while this screen is open.
class const AiAssistantScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AiRepository>(
          create: (context) =>
              GeminiAiRepository(createGeminiModel(), context.read()),
        ),
        Provider(create: (context) => TaskDraftRepository(context.read())),
        Provider(
          create: (context) =>
              AiAssistantService(context.read(), context.read()),
        ),
        Provider(
          create: (context) => AiChatController(context.read(), context.read()),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: const VoiceInputScope(child: AiChatView()),
    );
  }
}
