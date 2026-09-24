import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/utils/extensions.dart';
import 'package:todo_app/src/constants/app_sizes.dart';
import 'package:todo_app/src/utils/date_formatter.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/date_cubit.dart';

const kTodoDeadlineKey = ValueKey('Todo-Deadline');

class DeadlineSection extends StatefulWidget {
  final DateTime? deadline;
  const DeadlineSection({super.key, required this.deadline});

  @override
  State<DeadlineSection> createState() => _DeadlineSectionState();
}

class _DeadlineSectionState extends State<DeadlineSection> {
  @override
  void initState() {
    super.initState();
    if (widget.deadline != null) {
      context.read<DateCubit>().getDate(widget.deadline!);
    }
  }

  Text _getDateText(BuildContext context, String text) {
    return Text(text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Deadline Title
        Text(context.loc.deadline),

        // Date Picker
        InkWell(
          key: kTodoDeadlineKey,
          onTap: () => _showDatePicker(context),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p16,
                vertical: Sizes.p8,
              ),
              child: BlocBuilder<DateCubit, DateTime?>(
                builder: (context, date) {
                  return _getDateText(
                    context,
                    date == null
                        ? context.loc.notChoosed
                        : kDateFormatter.format(date),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    DateTime? result = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
          keyboardType: TextInputType.datetime,
        );
      },
    );

    if (result != null && context.mounted) {
      context.read<DateCubit>().getDate(result);
    }
  }
}
