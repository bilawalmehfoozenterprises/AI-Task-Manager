import 'package:drift/drift.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';
import 'package:lifely/src/shared/task/data/task_row_mapper.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// What the task list needs from storage: all tasks, ticking, and deleting.
class TaskListRepository(final TaskDatabase _db) {
  /// Emits the full list again whenever any task changes.
  Stream<List<Task>> watchTasks() {
    return _db
        .select(_db.tasks)
        .watch()
        .map((rows) => rows.map((row) => row.toTask()).toList());
  }

  Future<void> setCompleted(int id, {required bool isCompleted}) async {
    final query = _db.update(_db.tasks)..where((t) => t.id.equals(id));
    await query.write(TasksCompanion(isCompleted: Value(isCompleted)));
  }

  Future<void> deleteTask(int id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }
}
