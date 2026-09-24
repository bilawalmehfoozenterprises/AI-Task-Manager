import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/features/ai_task/presentation/ai_task_input_screen.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/src/utils/extensions.dart';
import 'package:todo_app/src/features/todo_list/presentation/todo_list_view.dart';
import 'package:todo_app/src/features/add_todo/add_todo_screen.dart';

const kAddTodoKey = ValueKey('Add-Todo');
const kAITodoKey = ValueKey('AI-Todo');

class MyTodoScreen extends StatefulWidget {
  const MyTodoScreen({super.key});

  @override
  State<MyTodoScreen> createState() => _MyTodoScreenState();
}

class _MyTodoScreenState extends State<MyTodoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.myTodos)),
      body: const TodoListView(),
      floatingActionButton: _AiAndAddTodoButtons(
        onAddTodoPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const AddTodoScreen())),
        onAiTodoPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AiTaskInputScreen()),
        ),
      ),
    );
  }
}

class _AiAndAddTodoButtons extends StatelessWidget {
  const _AiAndAddTodoButtons({
    required this.onAddTodoPressed,
    required this.onAiTodoPressed,
  });

  final VoidCallback onAddTodoPressed;
  final VoidCallback onAiTodoPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          key: kAITodoKey,
          heroTag: 'ai_fab',
          onPressed: onAiTodoPressed,
          child: const Icon(Icons.psychology_alt),
        ),
        gapH16,
        FloatingActionButton(
          key: kAddTodoKey,
          heroTag: 'add_todo_fab',
          onPressed: onAddTodoPressed,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
