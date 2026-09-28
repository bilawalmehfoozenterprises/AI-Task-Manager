import 'package:lifely/src/core/localization/app_localizations.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';

/// The text shown for each app-written assistant message.
extension ChatNoticeText on ChatNotice {
  String message(AppLocalizations loc) => switch (this) {
    .draftReady => loc.aiDraftReady,
    .taskSaved => loc.aiTaskSaved,
    .saveFailed => loc.saveTaskFailed,
    .busy => loc.aiBusy,
    .unavailable => loc.aiUnavailable,
    .invalidReply => loc.aiInvalidReply,
  };
}
