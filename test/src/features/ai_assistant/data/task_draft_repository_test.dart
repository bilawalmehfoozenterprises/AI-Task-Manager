import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/features/ai_assistant/data/task_draft_repository.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_database.dart';

void main() {
  late TaskDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  test('saveDraft stores the draft as a new task', () async {
    await TaskDraftRepository(db).saveDraft(testDraft);

    final row = await db.select(db.tasks).getSingle();
    expect(row.title, testDraft.title);
    expect(row.description, testDraft.description);
    expect(row.deadline, testDraft.deadline);
    expect(row.isCompleted, isFalse);
  });
}
