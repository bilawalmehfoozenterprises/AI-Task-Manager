import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/common/message.dart';
import 'package:todo_app/src/common/loading.dart';
import 'package:todo_app/src/utils/extensions.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/features/todo_list/domain/todo_model.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_state.dart';
import 'package:todo_app/src/features/todo_list/presentation/todo_list_tile.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        if (state is TodoError) {
          return CenteredMessage(message: state.message);
        } else if (state is TodoLoaded) {
          return _buildTodoList(context, state.todos);
        }
        return const CenteredLoading();
      },
    );
  }

  Widget _buildTodoList(BuildContext context, List<Todo> todos) {
    final incompletedTodos = todos.where((todo) => !todo.isCompleted).toList();
    final completedTodos = todos.where((todo) => todo.isCompleted).toList();

    if (incompletedTodos.isEmpty && completedTodos.isEmpty) {
      return CenteredMessage(message: context.loc.noTodoFound);
    }

    return Column(
      children: [
        // Incompleted Todos ListView
        _buildListSection(
          context: context,
          todos: incompletedTodos,
          emptyMessage: context.loc.noTodoFound,
        ),

        // Completed Todos ListView (only if there are completed todos)
        if (completedTodos.isNotEmpty)
          _buildListSection(
            context: context,
            todos: completedTodos,
            sectionTitle: context.loc.completedTodos,
          ),
      ],
    );
  }

  Widget _buildListSection({
    required BuildContext context,
    required List<Todo> todos,
    String? sectionTitle,
    String? emptyMessage,
  }) {
    if (todos.isEmpty && emptyMessage != null) {
      return Expanded(child: CenteredMessage(message: emptyMessage));
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionTitle != null) _buildSectionTitle(context, sectionTitle),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return TodoListTile(todo: todos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: Sizes.p8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p8,
          horizontal: Sizes.p16,
        ),
        child: Text(title, style: context.txtTheme.titleMedium),
      ),
    );
  }
}
