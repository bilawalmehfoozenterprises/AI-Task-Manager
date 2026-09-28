import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/routing/app_routes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/utils/date_formatter.dart';
import 'package:lifely/src/core/widgets/confirm_dialog.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_burst.dart';
import 'package:lifely/src/features/task_list/presentation/controller/letter_effect_controller.dart';
import 'package:lifely/src/features/task_list/presentation/controller/task_list_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/task_title_letters.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

/// One task row: tap to open, tick to complete, swipe left to delete.
/// Ticking, unticking and deleting send the title's letters flying.
class const TaskTile({super.key, required final Task task})
    extends StatefulWidget {
  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final _titleKey = GlobalKey();
  final _tileKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final controller = context.read<TaskListController>();
    return Padding(
      padding: const .only(bottom: Sizes.p8),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: .endToStart,
        background: ColoredBox(color: context.color.error),
        confirmDismiss: (_) => _confirmDelete(context),
        onDismissed: (_) => controller.deleteTask(task.id),
        child: ListTile(
          key: _tileKey,
          onTap: () => context.pushNamed(
            AppRoute.taskDetails.name,
            pathParameters: {AppRoute.taskIdParam: '${task.id}'},
          ),
          title: Text(
            task.title,
            key: _titleKey,
            style: TextStyle(
              decoration: task.isCompleted ? .lineThrough : null,
            ),
          ),
          subtitle: task.isCompleted
              ? null
              : Text(
                  '${context.loc.deadline} ${kDateFormatter.format(task.deadline)}',
                ),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              _playLetters(task.isCompleted ? .rise : .fall);
              controller.toggleCompletion(task);
            },
          ),
        ),
      ),
    );
  }

  void _playLetters(LetterMotion motion) {
    if (MediaQuery.disableAnimationsOf(context)) return;
    final burst = taskTitleLetters(
      row: context,
      title: _titleKey,
      tile: _tileKey,
      motion: motion,
    );
    if (burst != null) context.read<LetterEffectController>().play(burst);
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: context.loc.deleteTaskTitle,
      content: context.loc.deleteTaskBody,
      cancelText: context.loc.cancel,
      confirmText: context.loc.delete,
    );
    final delete = confirmed ?? false;
    if (delete && context.mounted) _playLetters(.blowAway);
    return delete;
  }
}
