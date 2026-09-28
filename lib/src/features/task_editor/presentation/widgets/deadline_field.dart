import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/utils/date_formatter.dart';
import 'package:lifely/src/features/task_editor/presentation/controller/task_editor_controller.dart';

const kTaskDeadlineKey = ValueKey('Task-Deadline');

/// Shows the chosen deadline; tap it to pick a date.
class const DeadlineField({super.key}) extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final deadline = context.read<TaskEditorController>().deadline.value;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(context.loc.deadline),
        InkWell(
          key: kTaskDeadlineKey,
          onTap: () => _pickDate(context, deadline),
          child: Card(
            child: Padding(
              padding: const .symmetric(
                horizontal: Sizes.p16,
                vertical: Sizes.p8,
              ),
              child: Text(
                deadline == null
                    ? context.loc.notChosen
                    : kDateFormatter.format(deadline),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime? current) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(2100),
      initialDate: current != null && !current.isBefore(today)
          ? current
          : today,
    );
    if (picked != null && context.mounted) {
      context.read<TaskEditorController>().setDeadline(picked);
    }
  }
}
