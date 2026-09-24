import 'package:lifely/src/features/task_editor/domain/task_form_error.dart';
import 'package:lifely/src/features/task_editor/data/task_editor_repository.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// The task form's rules: what counts as valid, and how it's saved.
class TaskEditorService(final TaskEditorRepository _repository) {
  Future<Task?> loadTask(int id) => _repository.fetchTask(id);

  /// Returns the first problem with the form, or null when it's valid.
  TaskFormError? validate({
    required String title,
    required String description,
    required DateTime? deadline,
  }) {
    if (title.trim().isEmpty) return .emptyTitle;
    if (description.trim().isEmpty) return .emptyDescription;
    if (deadline == null) return .missingDeadline;
    return null;
  }

  /// Updates [original] when given, otherwise creates a new task.
  Future<void> save({
    required Task? original,
    required String title,
    required String description,
    required DateTime deadline,
  }) {
    if (original != null) {
      return _repository.updateTask(
        original.copyWith(
          title: title.trim(),
          description: description.trim(),
          deadline: deadline,
        ),
      );
    }
    return _repository.addTask(
      title: title.trim(),
      description: description.trim(),
      deadline: deadline,
    );
  }
}
