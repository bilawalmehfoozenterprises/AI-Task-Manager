import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/src/app_initializer.dart';

import 'package:todo_app/src/common/message.dart';
import 'package:todo_app/src/features/add_todo/add_todo_screen.dart';
import 'package:todo_app/src/features/add_todo/deadline_section.dart';
import 'package:todo_app/src/features/todo_list/presentation/my_todo_screen.dart';
import 'package:todo_app/src/features/todo_list/presentation/todo_list_tile.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
      'tap on the floating action button, verify that a new task is created',
      (tester) async {
        await tester.pumpWidget(
          await AppInitializer(forTesting: true).initializeAndRun(),
        );
        await tester.pumpAndSettle();

        // Verify Empty Message
        expect(find.byType(CenteredMessage), findsOneWidget);

        // Tap the floating action button.
        await tester.tap(find.byKey(kAddTodoKey));
        await tester.pumpAndSettle();

        // Enter todo name
        await tester.enterText(find.byKey(kTodoNameKey), 'Test Task');
        await tester.pumpAndSettle();

        // Enter todo description
        await tester.enterText(find.byKey(kTodoDescriptionKey), 'Testing...');
        await tester.pumpAndSettle();

        // Setup todo deadline
        await tester.tap(find.byKey(kTodoDeadlineKey));
        await tester.pumpAndSettle();
        await tester.tap(find.text(DateTime.now().day.toString()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Tap the save button
        await tester.tap(find.byKey(kSaveTodoKey));
        await tester.pumpAndSettle();

        // Verify that the new task is displayed
        expect(find.byType(TodoListTile), findsOneWidget);
        expect(find.text('Test Task'), findsOneWidget);
      },
    );
  });
}
