import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/utils/date_formatter.dart';

/// "⏰ Deadline:" on the left, the date in a card on the right.
class const TaskDeadlineRow({super.key, required final DateTime deadline})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          spacing: Sizes.p8,
          children: [
            const Icon(Icons.alarm_rounded, size: Sizes.p24),
            Text(context.loc.deadline, style: context.txtTheme.bodyLarge),
          ],
        ),
        Card(
          child: Padding(
            padding: const .symmetric(
              horizontal: Sizes.p20,
              vertical: Sizes.p12,
            ),
            child: Text(
              kDateFormatter.format(deadline),
              style: context.txtTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
