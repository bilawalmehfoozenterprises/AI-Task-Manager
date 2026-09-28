import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/features/ai_assistant/application/ai_assistant_service.dart';
import 'package:lifely/src/features/ai_assistant/domain/task_draft.dart';
import 'package:lifely/src/features/task_editor/data/task_editor_repository.dart';
import 'package:lifely/src/features/task_list/data/task_list_repository.dart';
import 'package:lifely/src/shared/task/domain/task.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements Logger;

class MockTaskListRepository extends Mock implements TaskListRepository;

class MockTaskEditorRepository extends Mock implements TaskEditorRepository;

class MockAiAssistantService extends Mock implements AiAssistantService;

final testTask = Task(
  id: 1,
  title: 'Buy groceries',
  description: 'Milk and eggs',
  deadline: DateTime(2026, 10, 1),
);

final testDraft = TaskDraft(
  title: 'Call mom',
  description: 'Sunday evening call',
  deadline: DateTime(2026, 9, 27),
);
