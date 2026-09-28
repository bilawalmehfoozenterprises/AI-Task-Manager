import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lifely/src/app/bootstrap.dart';
import 'package:lifely/src/core/widgets/centered_message.dart';
import 'package:lifely/src/features/task_editor/presentation/widgets/deadline_field.dart';
import 'package:lifely/src/features/task_editor/presentation/widgets/task_editor_form.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list/task_list_fabs.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list/task_tile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('adding a task shows it in the list', (tester) async {
    await tester.pumpWidget(await bootstrap(forTesting: true));
    await tester.pumpAndSettle();
    expect(find.byType(CenteredMessage), findsWidgets);

    await tester.tap(find.byKey(kAddTaskKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(kTaskTitleKey), 'Test Task');
    await tester.enterText(find.byKey(kTaskDescriptionKey), 'Testing...');

    await tester.tap(find.byKey(kTaskDeadlineKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(DateTime.now().day.toString()));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(kSaveTaskKey));
    await tester.pumpAndSettle();

    expect(find.byType(TaskTile), findsOneWidget);
    expect(find.text('Test Task'), findsOneWidget);
  });
}
