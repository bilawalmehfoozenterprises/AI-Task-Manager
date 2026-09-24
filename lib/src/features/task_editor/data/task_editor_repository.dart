import 'package:drift/drift.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';
import 'package:lifely/src/shared/task/data/task_row_mapper.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// What the editor needs from storage: load a task, add one, update one.
class TaskEditorRepository(final TaskDatabase _db) {
  Future<Task?> fetchTask(int id) async {
    final query = _db.select(_db.tasks)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toTask();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime deadline,
  }) async {
    await _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            title: title,
            description: Value(description),
            deadline: deadline,
          ),
        );
  }

  Future<void> updateTask(Task task) async {
    final query = _db.update(_db.tasks)..where((t) => t.id.equals(task.id));
    await query.write(task.toCompanion());
  }
}
