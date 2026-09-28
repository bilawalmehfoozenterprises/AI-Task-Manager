import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/features/task_details/data/task_details_repository.dart';
import 'package:lifely/src/features/task_details/presentation/controller/task_details_controller.dart';
import 'package:lifely/src/features/task_details/presentation/widgets/task_details_view.dart';

/// Shows one task, with buttons to edit or delete it.
class const TaskDetailsScreen({super.key, required final int taskId})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => TaskDetailsRepository(context.read())),
        Provider(
          create: (context) =>
              TaskDetailsController(taskId, context.read(), context.read()),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: const Scaffold(body: SafeArea(child: TaskDetailsView())),
    );
  }
}
