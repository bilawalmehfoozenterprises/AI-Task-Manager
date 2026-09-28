import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/core/routing/app_routes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/confirm_dialog.dart';
import 'package:lifely/src/features/task_details/presentation/controller/task_details_controller.dart';

/// Close button on the left, delete button on the right.
class const TaskDetailsTopBar({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labels = MaterialLocalizations.of(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.close),
          tooltip: labels.closeButtonTooltip,
          onPressed: () => context.pop(),
        ),
        IconButton.filledTonal(
          icon: const Icon(Icons.delete),
          color: context.color.error,
          tooltip: labels.deleteButtonTooltip,
          onPressed: () => _confirmAndDelete(context),
        ),
      ],
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: context.loc.deleteTaskTitle,
      content: context.loc.deleteTaskBody,
      cancelText: context.loc.cancel,
      confirmText: context.loc.delete,
    );
    if (confirmed != true || !context.mounted) return;
    final deleted = await context.read<TaskDetailsController>().deleteTask();
    if (deleted && context.mounted) context.goNamed(AppRoute.home.name);
  }
}
