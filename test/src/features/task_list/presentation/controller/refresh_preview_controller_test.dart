import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_outcome.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_preview_controller.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_variant.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late MockLogger logger;
  late Completer<void> gate;
  late int calls;
  late RefreshPreviewController controller;

  setUp(() {
    logger = MockLogger();
    gate = Completer<void>();
    calls = 0;
    controller = RefreshPreviewController(
      logger,
      operation: () {
        calls++;
        return gate.future;
      },
      timeout: const Duration(seconds: 1),
    );
  });

  tearDown(() => controller.dispose());

  test('starts with the tornado and nothing running', () {
    expect(controller.selected.value, RefreshVariant.tornado);
    expect(controller.busy.value, isFalse);
    expect(calls, 0);
  });

  test('one run calls the operation once and reports success', () async {
    final result = controller.run();
    expect(controller.busy.value, isTrue);
    gate.complete();
    expect(await result, RefreshOutcome.succeeded);
    expect(calls, 1);
    controller.finish();
    expect(controller.busy.value, isFalse);
  });

  test('a second run while busy is ignored', () async {
    final first = controller.run();
    expect(await controller.run(), RefreshOutcome.cancelled);
    gate.complete();
    await first;
    expect(calls, 1);
  });

  test('the variant stays latched while running', () async {
    final result = controller.run();
    expect(controller.select(.buddy), isFalse);
    expect(controller.selected.value, RefreshVariant.tornado);
    expect(controller.latched.value, RefreshVariant.tornado);
    gate.complete();
    await result;
    controller.finish();
    expect(controller.select(.buddy), isTrue);
    expect(controller.selected.value, RefreshVariant.buddy);
  });

  test('a failure is logged and reported as failed', () async {
    final result = controller.run();
    gate.completeError(StateError('boom'));
    expect(await result, RefreshOutcome.failed);
    verify(
      () => logger.severe(
        any(),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).called(1);
  });

  test('a preview cannot start while busy', () async {
    controller.requestPreview();
    expect(controller.previewRequests.value, 1);
    final result = controller.run();
    expect(controller.requestPreview(), isFalse);
    expect(controller.previewRequests.value, 1);
    gate.complete();
    await result;
  });

  test('a timeout counts as a failure', () {
    fakeAsync((async) {
      RefreshOutcome? outcome;
      controller.run().then((value) => outcome = value);
      async.elapse(const Duration(seconds: 2));
      expect(outcome, RefreshOutcome.failed);
    });
  });

  test('a result that arrives after dispose is cancelled', () async {
    final result = controller.run();
    controller.dispose();
    gate.complete();
    expect(await result, RefreshOutcome.cancelled);
  });
}
