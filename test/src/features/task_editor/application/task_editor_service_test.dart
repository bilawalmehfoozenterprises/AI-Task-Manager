import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_editor/application/task_editor_service.dart';
import 'package:lifely/src/features/task_editor/domain/task_form_error.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockTaskEditorRepository repository;
  late TaskEditorService service;
  final deadline = DateTime(2026, 10, 1);

  setUpAll(() => registerFallbackValue(testTask));

  setUp(() {
    repository = MockTaskEditorRepository();
    service = TaskEditorService(repository);
  });

  group('validate', () {
    test('rejects a blank title', () {
      expect(
        service.validate(title: '  ', description: 'd', deadline: deadline),
        TaskFormError.emptyTitle,
      );
    });

    test('rejects a blank description', () {
      expect(
        service.validate(title: 't', description: '', deadline: deadline),
        TaskFormError.emptyDescription,
      );
    });

    test('rejects a missing deadline', () {
      expect(
        service.validate(title: 't', description: 'd', deadline: null),
        TaskFormError.missingDeadline,
      );
    });

    test('accepts a complete form', () {
      expect(
        service.validate(title: 't', description: 'd', deadline: deadline),
        isNull,
      );
    });
  });

  group('save', () {
    test('adds a new task with trimmed text', () async {
      when(
        () => repository.addTask(
          title: any(named: 'title'),
          description: any(named: 'description'),
          deadline: any(named: 'deadline'),
        ),
      ).thenAnswer((_) async {});

      await service.save(
        original: null,
        title: ' Title ',
        description: ' Notes ',
        deadline: deadline,
      );

      verify(
        () => repository.addTask(
          title: 'Title',
          description: 'Notes',
          deadline: deadline,
        ),
      ).called(1);
    });

    test('updates the original task when editing', () async {
      when(() => repository.updateTask(any())).thenAnswer((_) async {});

      await service.save(
        original: testTask,
        title: 'Renamed',
        description: testTask.description,
        deadline: deadline,
      );

      verify(
        () => repository.updateTask(
          testTask.copyWith(title: 'Renamed', deadline: deadline),
        ),
      ).called(1);
    });
  });
}
