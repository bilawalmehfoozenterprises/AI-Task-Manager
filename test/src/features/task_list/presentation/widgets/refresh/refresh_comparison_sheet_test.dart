import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/core/localization/app_localizations.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_preview_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/refresh_comparison_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../../../helpers/mocks.dart';

void main() {
  testWidgets('the sheet picks a variant and asks for a preview', (
    tester,
  ) async {
    final controller = RefreshPreviewController(MockLogger());
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      Provider.value(
        value: controller,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const Scaffold(body: RefreshComparisonSheet()),
        ),
      ),
    );

    await tester.tap(find.text('Buddy'));
    await tester.pump();
    expect(controller.selected.value.name, 'buddy');

    await tester.tap(find.text('Preview'));
    await tester.pump();
    expect(controller.previewRequests.value, 1);
  });
}
