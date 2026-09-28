import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/features/task_list/data/task_list_repository.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_effect_controller.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/letter_layer.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list_app_bar.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list_fabs.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_list_view.dart';

/// Home screen: tasks in two tabs, Pending and Completed.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => TaskListRepository(context.read())),
        Provider(
          create: (context) =>
              TaskListController(context.read(), context.read()),
          dispose: (_, controller) => controller.dispose(),
        ),
        Provider(
          create: (_) => LetterEffectController(),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          // Letters fly over the list but under the floating buttons.
          body: Stack(
            fit: .expand,
            children: [
              NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (_, isScrolled) => [
                  TaskListAppBar(isScrolled: isScrolled),
                ],
                body: const TaskListView(),
              ),
              const LetterLayer(),
            ],
          ),
          floatingActionButton: const TaskListFabs(),
        ),
      ),
    );
  }
}
