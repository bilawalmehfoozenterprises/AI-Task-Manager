import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/task_list/data/task_list_repository.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// Keeps the task list in sync with the database and handles list actions.
class TaskListController(
  final TaskListRepository _repository,
  final Logger _logger,
) {
  /// All tasks: loading, then data (updated live) or an error.
  late final tasks = streamSignal(_watchTasks);

  late final pendingTasks = computed(() => _where(completed: false));
  late final completedTasks = computed(() => _where(completed: true));

  Future<void> toggleCompletion(Task task) {
    return _run(
      'toggle task ${task.id}',
      () => _repository.setCompleted(task.id, isCompleted: !task.isCompleted),
    );
  }

  Future<void> deleteTask(int id) {
    return _run('delete task $id', () => _repository.deleteTask(id));
  }

  void dispose() {
    tasks.dispose();
    pendingTasks.dispose();
    completedTasks.dispose();
  }

  List<Task> _where({required bool completed}) {
    final all = tasks.value.value ?? const <Task>[];
    return all.where((task) => task.isCompleted == completed).toList();
  }

  Stream<List<Task>> _watchTasks() {
    return _repository.watchTasks().handleError((
      Object error,
      StackTrace stackTrace,
    ) {
      _logger.severe(
        'Failed to load tasks',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  Future<void> _run(String action, Future<void> Function() body) async {
    try {
      await body();
    } catch (error, stackTrace) {
      _logger.severe('Failed to $action', error: error, stackTrace: stackTrace);
    }
  }
}
