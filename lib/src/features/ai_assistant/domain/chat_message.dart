import 'package:equatable/equatable.dart';

enum ChatSender { user, assistant }

/// App-written assistant messages; the screen shows them in the user's language.
enum ChatNotice {
  draftReady,
  taskSaved,
  saveFailed,
  busy,
  unavailable,
  invalidReply,
}

/// One message in the chat: free text, or a [ChatNotice] from the app.
class ChatMessage extends Equatable {
  const new user(String this.text) : sender = .user, notice = null;

  const new assistant(String this.text) : sender = .assistant, notice = null;

  const new notice(ChatNotice this.notice) : sender = .assistant, text = null;

  final ChatSender sender;
  final String? text;
  final ChatNotice? notice;

  @override
  List<Object?> get props => [sender, text, notice];
}
