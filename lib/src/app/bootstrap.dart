import 'package:material_ui/material_ui.dart';
import 'package:lifely/src/app/app.dart';
import 'package:lifely/src/app/app_scope.dart';
import 'package:lifely/src/app/error_handlers.dart';
import 'package:lifely/src/app/firebase_setup.dart';
import 'package:lifely/src/app/router.dart';
import 'package:lifely/src/core/logging/app_logger.dart';

/// Prepares everything the app needs, then returns the root widget.
/// [forTesting] skips Firebase and keeps the database in memory.
Future<Widget> bootstrap({bool forTesting = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = AppLogger(reportToCrashlytics: !forTesting);
  if (!forTesting) {
    await setupFirebase();
    registerErrorHandlers(logger);
  }
  return AppScope(
    logger: logger,
    inMemoryDatabase: forTesting,
    child: LifelyApp(router: createRouter()),
  );
}
