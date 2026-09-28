import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/task_editor/application/task_editor_service.dart';
import 'package:lifely/src/features/task_editor/presentation/controller/save_task_outcome.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// Holds the form's deadline and runs validation and saving.
class TaskEditorController {
  TaskEditorController(this._service, this._logger, {int? taskId})
    : isLoading = signal(taskId != null) {
    if (taskId != null) _load(taskId);
  }

  final TaskEditorService _service;
  final Logger _logger;

  /// True while an existing task is being loaded for editing.
  final Signal<bool> isLoading;

  /// The task being edited, or null when creating a new one.
  final original = signal<Task?>(null);
  final deadline = signal<DateTime?>(null);
  final isSaving = signal(false);

  void setDeadline(DateTime value) => deadline.value = value;

  Future<SaveTaskOutcome> save({
    required String title,
    required String description,
  }) async {
    final error = _service.validate(
      title: title,
      description: description,
      deadline: deadline.value,
    );
    final chosenDeadline = deadline.value;
    if (error != null) return TaskFormInvalid(error);
    if (chosenDeadline == null) return const TaskSaveFailed();
    isSaving.value = true;
    try {
      await _service.save(
        original: original.value,
        title: title,
        description: description,
        deadline: chosenDeadline,
      );
      return const TaskSaved();
    } catch (error, stackTrace) {
      _logger.severe(
        'Failed to save task',
        error: error,
        stackTrace: stackTrace,
      );
      return const TaskSaveFailed();
    } finally {
      isSaving.value = false;
    }
  }

  void dispose() {
    for (final s in <ReadonlySignal<Object?>>[
      isLoading,
      original,
      deadline,
      isSaving,
    ]) {
      s.dispose();
    }
  }

  Future<void> _load(int taskId) async {
    final task = await _service.loadTask(taskId);
    batch(() {
      original.value = task;
      deadline.value = task?.deadline;
      isLoading.value = false;
    });
  }
}
