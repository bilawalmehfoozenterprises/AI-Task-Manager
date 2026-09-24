import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/data/task_list_repository.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list_fabs.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list_view.dart';

/// Home screen: all tasks, split into pending and completed.
class const TaskListScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => TaskListRepository(context.read())),
        Provider(
          create: (context) {
            return TaskListController(context.read(), context.read());
          },
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.myTasks)),
        body: const TaskListView(),
        floatingActionButton: const TaskListFabs(),
      ),
    );
  }
}
