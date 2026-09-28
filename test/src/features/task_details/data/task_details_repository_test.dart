import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_details/data/task_details_repository.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

import '../../../../helpers/test_database.dart';

void main() {
  late TaskDatabase db;
  late TaskDetailsRepository repository;

  setUp(() {
    db = createTestDatabase();
    repository = TaskDetailsRepository(db);
  });

  tearDown(() => db.close());

  test('watchTask emits the task', () async {
    final id = await insertTestTask(db, title: 'Read a book');

    final task = await repository.watchTask(id).first;

    expect(task?.title, 'Read a book');
  });

  test('watchTask emits null after the task is deleted', () async {
    final id = await insertTestTask(db);

    await repository.deleteTask(id);

    expect(await repository.watchTask(id).first, isNull);
  });
}
