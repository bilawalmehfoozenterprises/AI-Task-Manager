/// Where voice input stands right now.
enum VoiceInputStatus {
  /// Still asking for permission and starting up.
  preparing,

  /// No mic permission, or speech recognition isn't supported.
  unavailable,

  /// Ready to start listening.
  ready,

  listening,
}
