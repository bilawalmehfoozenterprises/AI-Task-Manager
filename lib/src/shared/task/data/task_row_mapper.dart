import 'package:drift/drift.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// Converts database rows into [Task] models.
extension TaskRowMapper on TaskRow {
  Task toTask() {
    return Task(
      id: id,
      title: title,
      description: description ?? '',
      deadline: deadline,
      isCompleted: isCompleted,
    );
  }
}

/// Converts a [Task] into the values written to the database.
extension TaskCompanionMapper on Task {
  TasksCompanion toCompanion() {
    return TasksCompanion(
      title: Value(title),
      description: Value(description),
      deadline: Value(deadline),
      isCompleted: Value(isCompleted),
    );
  }
}
