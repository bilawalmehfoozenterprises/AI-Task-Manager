import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/ai_assistant/data/ai_reply_decoder.dart';
import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';

void main() {
  const invalid = AiFailure(.invalidReply);

  test('reads a ready task', () {
    final reply = decodeAiReply(
      '{"status":"task_ready","task":{"title":"Call mom",'
      '"description":"Sunday","deadline":"2026-09-27"}}',
    );

    expect(
      reply,
      AiTaskReady(
        TaskDraft(
          title: 'Call mom',
          description: 'Sunday',
          deadline: DateTime(2026, 9, 27),
        ),
      ),
    );
  });

  test('reads JSON wrapped in a markdown code fence', () {
    final reply = decodeAiReply(
      '```json\n{"status":"clarification_needed","question":"When?"}\n```\n',
    );

    expect(reply, const AiClarification('When?'));
  });

  test('treats a task without a valid deadline as invalid', () {
    final reply = decodeAiReply(
      '{"status":"task_ready","task":{"title":"X","deadline":"soon"}}',
    );

    expect(reply, invalid);
  });

  test('treats an unknown status as invalid', () {
    expect(decodeAiReply('{"status":"maybe"}'), invalid);
  });

  test('treats text without JSON as invalid', () {
    expect(decodeAiReply('Sorry, I cannot help.'), invalid);
  });
}
