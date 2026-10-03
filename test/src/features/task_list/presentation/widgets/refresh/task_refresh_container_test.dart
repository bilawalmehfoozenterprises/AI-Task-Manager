import 'package:flutter_test/flutter_test.dart';
import 'package:lifely/src/core/localization/app_localizations.dart';
import 'package:lifely/src/features/task_list/presentation/controller/refresh_preview_controller.dart';
import 'package:lifely/src/features/task_list/presentation/widgets/refresh/task_refresh_container.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../../../../helpers/mocks.dart';

void main() {
  // Without --dart-define the container adds nothing, so only the always-on
  // parts are checked here.
  testWidgets('leaves the list alone when the comparison is off', (
    tester,
  ) async {
    final controller = RefreshPreviewController(MockLogger());
    addTearDown(controller.dispose);
    ScrollPhysics? seen = const ClampingScrollPhysics();

    await tester.pumpWidget(
      Provider.value(
        value: controller,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: DefaultTabController(
            length: 1,
            child: TaskRefreshContainer(
              tabIndex: 0,
              builder: (_, header, physics) {
                seen = physics;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );

    expect(seen, isNull);
  });
}
