import 'package:lifely/src/shared/task/data/task_database.dart';
import 'package:lifely/src/shared/task/data/task_row_mapper.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// What the details screen needs from storage: follow one task, delete it.
class TaskDetailsRepository(final TaskDatabase _db) {
  /// Emits the task on every change, and null once it no longer exists.
  Stream<Task?> watchTask(int id) {
    final query = _db.select(_db.tasks)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map((row) => row?.toTask());
  }

  Future<void> deleteTask(int id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }
}
