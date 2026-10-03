import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_preview_controller.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_variant.dart';

/// Opens the comparison sheet. Temporary, until a winner is picked.
Future<void> showRefreshComparisonSheet(BuildContext context) {
  final controller = context.read<RefreshPreviewController>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => Provider.value(
      value: controller,
      child: const RefreshComparisonSheet(),
    ),
  );
}

class RefreshComparisonSheet extends SignalWidget {
  const RefreshComparisonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RefreshPreviewController>();
    final busy = controller.busy.value;
    return SingleChildScrollView(
      padding: const .all(Sizes.p24),
      child: Column(
        spacing: Sizes.p16,
        crossAxisAlignment: .stretch,
        children: [
          Text(context.loc.compareRefresh, style: context.txtTheme.titleLarge),
          Text(context.loc.refreshPreviewLabel),
          SegmentedButton<RefreshVariant>(
            segments: [
              ButtonSegment(
                value: .tornado,
                label: Text(context.loc.refreshTornado),
              ),
              ButtonSegment(
                value: .buddy,
                label: Text(context.loc.refreshBuddy),
              ),
            ],
            selected: {controller.selected.value},
            onSelectionChanged: busy
                ? null
                : (picked) => controller.select(picked.first),
          ),
          if (busy) Text(context.loc.refreshBusy),
          FilledButton(
            onPressed: busy
                ? null
                : () {
                    Navigator.of(context).pop();
                    controller.requestPreview();
                  },
            child: Text(context.loc.refreshPreviewButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.loc.close),
          ),
        ],
      ),
    );
  }
}
