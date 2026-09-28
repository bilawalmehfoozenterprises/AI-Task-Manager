import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/features/task_editor/application/task_editor_service.dart';
import 'package:lifely/src/features/task_editor/data/task_editor_repository.dart';
import 'package:lifely/src/features/task_editor/presentation/controller/task_editor_controller.dart';
import 'package:lifely/src/features/task_editor/presentation/widgets/task_editor_view.dart';

/// Creates a new task, or edits the task with [taskId].
class const TaskEditorScreen({super.key, final int? taskId})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => TaskEditorRepository(context.read())),
        Provider(create: (context) => TaskEditorService(context.read())),
        Provider(
          create: (context) => TaskEditorController(
            context.read(),
            context.read(),
            taskId: taskId,
          ),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: TaskEditorView(isEditing: taskId != null),
    );
  }
}
