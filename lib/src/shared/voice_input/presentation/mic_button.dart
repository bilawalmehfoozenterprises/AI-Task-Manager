import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/shared/voice_input/domain/voice_input_status.dart';
import 'package:lifely/src/shared/voice_input/presentation/voice_input_controller.dart';

/// Mic button: starts listening, shows a stop button while listening.
/// Needs a [VoiceInputScope] above it.
class const MicButton({
  super.key,

  /// Reads the text already typed, so heard words are added after it.
  required final String Function() typedText,
}) extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<VoiceInputController>();
    final status = controller.status.value;
    return switch (status) {
      VoiceInputStatus.listening => IconButton(
        icon: const Icon(Icons.stop),
        onPressed: controller.stop,
      ),
      VoiceInputStatus.ready => IconButton(
        icon: const Icon(Icons.mic),
        onPressed: () => controller.start(typedText: typedText()),
      ),
      VoiceInputStatus.preparing || VoiceInputStatus.unavailable => IconButton(
        icon: const Icon(Icons.mic_off),
        tooltip: context.loc.voiceUnavailable,
        onPressed: null,
      ),
    };
  }
}
