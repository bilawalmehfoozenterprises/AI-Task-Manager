/* Widget that represents an individual Todo item in a list.

   It displays the todo name, its completion status and Deadline

   It includes functionality like toggling completion or deleting the todo. 
*/

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/utils/date_formatter.dart';
import 'package:todo_app/src/utils/extensions.dart';
import 'package:todo_app/src/common/alert_dialogues.dart';
import 'package:todo_app/src/features/todo_list/domain/todo_model.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/src/features/todo_details/todo_detail_screen.dart';

class TodoListTile extends StatelessWidget {
  final Todo todo;

  const TodoListTile({super.key, required this.todo});

  void _onTap(BuildContext context, Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TodoDetailScreen(todo: todo)),
    );
  }

  Future<bool> confirmDismiss(
    BuildContext context,
    TodoCubit todoCubit,
    DismissDirection direction,
  ) async {
    if (direction == DismissDirection.endToStart) {
      final result = await showCustomAlertDialog(
        context: context,
        title: context.loc.todoDelete,
        content: context.loc.deleteTodoBody,
        cancelActionText: context.loc.cancel,
        defaultActionText: context.loc.delete,
      );

      if (result == true) {
        todoCubit.deleteTodo(todo.id);
      }
      return Future.value(result);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // Access the TodoCubit from the current context
    final cubit = context.read<TodoCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: InkWell(
        onTap: () => _onTap(context, todo),
        // Dismissible allows the user to swipe the tile to delete the todo
        child: Dismissible(
          key: ValueKey(todo.id),
          direction: DismissDirection.endToStart,
          background: Container(color: context.color.error),
          confirmDismiss: (dir) => confirmDismiss(context, cubit, dir),
          child: ListTile(
            title: _buildTitle(todo),
            subtitle: todo.isCompleted
                ? null
                : _buildDeadline(todo.deadline, context),

            trailing: _buildCheckBox(todo, cubit),
          ),
        ),
      ),
    );
  }

  /// Builds the title of the todo,
  /// and applies strikethrough if the todo is completed.
  Text _buildTitle(Todo todo) {
    return Text(
      todo.name,
      style: TextStyle(
        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
      ),
    );
  }

  Checkbox _buildCheckBox(Todo todo, TodoCubit cubit) {
    return Checkbox(
      value: todo.isCompleted,
      onChanged: (value) => cubit.toggleCompletion(todo),
    );
  }

  /// Displays the deadline of the todo as a subtitle.
  Text _buildDeadline(DateTime deadline, BuildContext context) {
    return Text('${context.loc.deadline} ${kDateFormatter.format(deadline)}');
  }
}
