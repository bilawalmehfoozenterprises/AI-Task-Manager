import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/ai_assistant/domain/ai_reply.dart';
import 'package:lifely/src/features/ai_assistant/domain/chat_message.dart';
import 'package:lifely/src/features/ai_assistant/presentation/controller/ai_chat_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late MockAiAssistantService service;
  late AiChatController controller;
  const text = 'Call mom on Sunday';

  setUpAll(() => registerFallbackValue(testDraft));

  setUp(() {
    service = MockAiAssistantService();
    controller = AiChatController(service, MockLogger());
  });

  tearDown(() => controller.dispose());

  void replyWith(AiReply reply) {
    when(
      () => service.ask(
        message: any(named: 'message'),
        history: any(named: 'history'),
      ),
    ).thenAnswer((_) async => reply);
  }

  test('a ready task is returned for confirmation', () async {
    replyWith(AiTaskReady(testDraft));

    final draft = await controller.send(text);

    expect(draft, testDraft);
    expect(controller.messages.value, const [
      ChatMessage.user(text),
      ChatMessage.notice(.draftReady),
    ]);
    expect(controller.isThinking.value, isFalse);
  });

  test('sends earlier messages as history, without the new message', () async {
    replyWith(const AiClarification('Which Sunday?'));

    await controller.send(text);

    verify(() => service.ask(message: text, history: const [])).called(1);
    expect(
      controller.messages.value.last,
      const ChatMessage.assistant('Which Sunday?'),
    );
  });

  test('a busy AI shows a friendly notice and no draft', () async {
    replyWith(const AiFailure(.busy));

    expect(await controller.send(text), isNull);
    expect(controller.messages.value.last, const ChatMessage.notice(.busy));
  });

  test('saveDraft saves the task and reports success', () async {
    when(() => service.saveDraft(any())).thenAnswer((_) async {});

    expect(await controller.saveDraft(testDraft), isTrue);
    expect(controller.messages.value, const [ChatMessage.notice(.taskSaved)]);
  });

  test('saveDraft reports failure when saving throws', () async {
    when(() => service.saveDraft(any())).thenThrow(Exception('db error'));

    expect(await controller.saveDraft(testDraft), isFalse);
    expect(controller.messages.value, const [ChatMessage.notice(.saveFailed)]);
  });
}
