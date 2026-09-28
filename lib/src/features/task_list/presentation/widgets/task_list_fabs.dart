import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/routing/app_routes.dart';

const kAddTaskKey = ValueKey('Add-Task');
const kAiAssistantKey = ValueKey('AI-Assistant');

/// The two floating buttons: open the AI assistant, or add a task by hand.
class const TaskListFabs({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Sizes.p16,
      mainAxisAlignment: .end,
      crossAxisAlignment: .end,
      children: [
        FloatingActionButton(
          key: kAiAssistantKey,
          heroTag: 'ai_fab',
          onPressed: () => context.pushNamed(AppRoute.aiAssistant.name),
          child: const Icon(Icons.psychology_alt),
        ),
        FloatingActionButton(
          key: kAddTaskKey,
          heroTag: 'add_task_fab',
          onPressed: () => context.pushNamed(AppRoute.newTask.name),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
