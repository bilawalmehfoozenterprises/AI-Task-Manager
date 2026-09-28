import 'package:go_router/go_router.dart';
import 'package:lifely/src/core/routing/app_routes.dart';
import 'package:lifely/src/features/ai_assistant/presentation/ai_assistant_screen.dart';
import 'package:lifely/src/features/task_details/presentation/task_details_screen.dart';
import 'package:lifely/src/features/task_editor/presentation/task_editor_screen.dart';
import 'package:lifely/src/features/task_list/presentation/task_list_screen.dart';

/// Maps each [AppRoute] to its path and screen.
GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (_, _) => const TaskListScreen(),
        routes: [
          GoRoute(
            path: 'tasks/new',
            name: AppRoute.newTask.name,
            builder: (_, _) => const TaskEditorScreen(),
          ),
          GoRoute(
            path: 'tasks/:${AppRoute.taskIdParam}',
            name: AppRoute.taskDetails.name,
            builder: (_, state) => TaskDetailsScreen(taskId: _taskId(state)),
            routes: [
              GoRoute(
                path: 'edit',
                name: AppRoute.editTask.name,
                builder: (_, state) => TaskEditorScreen(taskId: _taskId(state)),
              ),
            ],
          ),
          GoRoute(
            path: 'ai',
            name: AppRoute.aiAssistant.name,
            builder: (_, _) => const AiAssistantScreen(),
          ),
        ],
      ),
    ],
  );
}

/// An invalid id matches no task, so the screens treat it as missing.
int _taskId(GoRouterState state) {
  return int.tryParse(state.pathParameters[AppRoute.taskIdParam] ?? '') ?? -1;
}
