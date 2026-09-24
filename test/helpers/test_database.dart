import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

/// A fresh database that lives only in memory.
TaskDatabase createTestDatabase() =>
    TaskDatabase.forTesting(NativeDatabase.memory());

/// Inserts a task directly and returns its id.
Future<int> insertTestTask(
  TaskDatabase db, {
  String title = 'Sample',
  bool isCompleted = false,
}) {
  return db
      .into(db.tasks)
      .insert(
        TasksCompanion.insert(
          title: title,
          description: const Value('Description'),
          deadline: DateTime(2026, 10, 1),
          isCompleted: Value(isCompleted),
        ),
      );
}
