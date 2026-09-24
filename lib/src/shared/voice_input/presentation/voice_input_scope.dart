import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/shared/voice_input/application/voice_input_service.dart';
import 'package:lifely/src/shared/voice_input/data/mic_permission_repository.dart';
import 'package:lifely/src/shared/voice_input/data/speech_repository.dart';
import 'package:lifely/src/shared/voice_input/data/speech_to_text_repository.dart';
import 'package:lifely/src/shared/voice_input/presentation/voice_input_controller.dart';

/// Adds voice input below this widget. Wrap only screens that use the mic;
/// everything here is cleaned up when the screen closes.
class const VoiceInputScope({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MicPermissionRepository()),
        Provider<SpeechRepository>(
          create: (context) => SpeechToTextRepository(context.read()),
          dispose: (_, speech) => speech.dispose(),
        ),
        Provider(
          create: (context) =>
              VoiceInputService(context.read(), context.read()),
        ),
        Provider(
          create: (context) => VoiceInputController(context.read()),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: child,
    );
  }
}
