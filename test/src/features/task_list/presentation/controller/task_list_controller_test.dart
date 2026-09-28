import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/shared/task/domain/task.dart';
import 'package:mocktail/mocktail.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../helpers/mocks.dart';

void main() {
  late MockTaskListRepository repository;
  late TaskListController controller;
  final doneTask = testTask.copyWith(isCompleted: true);

  setUp(() {
    repository = MockTaskListRepository();
    controller = TaskListController(repository, MockLogger());
  });

  tearDown(() => controller.dispose());

  /// Reads the tasks signal once the stream's first event has arrived.
  Future<AsyncState<List<Task>>> settledTasks() async {
    controller.tasks.value;
    await Future<void>.delayed(Duration.zero);
    return controller.tasks.value;
  }

  test('shows the tasks, split into pending and completed', () async {
    when(repository.watchTasks)
        .thenAnswer((_) => Stream.value([testTask, doneTask]));

    expect(await settledTasks(), isA<AsyncData<List<Task>>>());
    expect(controller.pendingTasks.value, [testTask]);
    expect(controller.completedTasks.value, [doneTask]);
  });

  test('shows an error when loading fails', () async {
    when(repository.watchTasks)
        .thenAnswer((_) => Stream<List<Task>>.error(Exception('db error')));

    expect(await settledTasks(), isA<AsyncError<List<Task>>>());
  });

  test('toggleCompletion flips the completion flag', () async {
    when(
      () => repository.setCompleted(
        any(),
        isCompleted: any(named: 'isCompleted'),
      ),
    ).thenAnswer((_) async {});

    await controller.toggleCompletion(testTask);

    verify(() => repository.setCompleted(testTask.id, isCompleted: true))
        .called(1);
  });

  test('deleteTask removes the task by id', () async {
    when(() => repository.deleteTask(any())).thenAnswer((_) async {});

    await controller.deleteTask(testTask.id);

    verify(() => repository.deleteTask(testTask.id)).called(1);
  });
}
