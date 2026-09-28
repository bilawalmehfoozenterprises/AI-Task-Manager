import 'package:drift/drift.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

/// Saves a confirmed AI draft as a new task.
class TaskDraftRepository(final TaskDatabase _db) {
  Future<void> saveDraft(TaskDraft draft) async {
    await _db
        .into(_db.tasks)
        .insert(
          TasksCompanion.insert(
            title: draft.title,
            description: Value(draft.description),
            deadline: draft.deadline,
          ),
        );
  }
}
