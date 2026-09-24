import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/task_details/data/task_details_repository.dart';

/// Follows one task, so the screen updates after it's edited or deleted.
class TaskDetailsController(
  final int _taskId,
  final TaskDetailsRepository _repository,
  final Logger _logger,
) {
  /// The task, or data `null` once it no longer exists.
  late final task = streamSignal(() => _repository.watchTask(_taskId));

  /// Returns true when the task was deleted.
  Future<bool> deleteTask() async {
    try {
      await _repository.deleteTask(_taskId);
      return true;
    } catch (error, stackTrace) {
      _logger.severe(
        'Failed to delete task $_taskId',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  void dispose() => task.dispose();
}
