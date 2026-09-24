import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/data/task_list_repository.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

import '../../../../helpers/test_database.dart';

void main() {
  late TaskDatabase db;
  late TaskListRepository repository;

  setUp(() {
    db = createTestDatabase();
    repository = TaskListRepository(db);
  });

  tearDown(() => db.close());

  test('watchTasks emits the stored tasks', () async {
    await insertTestTask(db, title: 'Buy groceries');

    final tasks = await repository.watchTasks().first;

    expect(tasks.single.title, 'Buy groceries');
  });

  test('watchTasks emits again when a task is added', () async {
    final events = StreamIterator(repository.watchTasks());

    expect(await events.moveNext(), isTrue);
    expect(events.current, isEmpty);

    await insertTestTask(db);

    expect(await events.moveNext(), isTrue);
    expect(events.current, hasLength(1));
    await events.cancel();
  });

  test('setCompleted changes only the completion flag', () async {
    final id = await insertTestTask(db, title: 'Walk');

    await repository.setCompleted(id, isCompleted: true);

    final task = (await repository.watchTasks().first).single;
    expect(task.isCompleted, isTrue);
    expect(task.title, 'Walk');
  });

  test('deleteTask removes the task', () async {
    final id = await insertTestTask(db);

    await repository.deleteTask(id);

    expect(await repository.watchTasks().first, isEmpty);
  });
}
