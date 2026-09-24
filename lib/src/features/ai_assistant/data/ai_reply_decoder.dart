import 'dart:convert';

import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';

/// Turns the AI's raw text into an [AiReply].
/// Tolerates a markdown code fence around the JSON.
AiReply decodeAiReply(String raw) {
  final start = raw.indexOf('{');
  final end = raw.lastIndexOf('}');
  if (start == -1 || end < start) {
    return const AiFailure(.invalidReply);
  }
  final Object? json = jsonDecode(raw.substring(start, end + 1));
  return json is Map<String, Object?>
      ? AiReply.fromJson(json)
      : const AiFailure(.invalidReply);
}
