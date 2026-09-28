import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_editor/data/task_editor_repository.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

import '../../../../helpers/test_database.dart';

void main() {
  late TaskDatabase db;
  late TaskEditorRepository repository;

  setUp(() {
    db = createTestDatabase();
    repository = TaskEditorRepository(db);
  });

  tearDown(() => db.close());

  test('addTask stores a new, not completed task', () async {
    await repository.addTask(
      title: 'Gym',
      description: 'Leg day',
      deadline: DateTime(2026, 10, 2),
    );

    final task = await repository.fetchTask(1);
    expect(task?.title, 'Gym');
    expect(task?.description, 'Leg day');
    expect(task?.isCompleted, isFalse);
  });

  test('updateTask saves the changed fields', () async {
    final id = await insertTestTask(db, title: 'Old');
    final task = await repository.fetchTask(id);

    await repository.updateTask(task!.copyWith(title: 'New'));

    expect((await repository.fetchTask(id))?.title, 'New');
  });

  test('fetchTask returns null for an unknown id', () async {
    expect(await repository.fetchTask(99), isNull);
  });
}
