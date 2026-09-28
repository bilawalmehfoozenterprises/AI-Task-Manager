import 'package:drift/native.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:lifely/src/core/logging/logger.dart';
import 'package:lifely/src/shared/task/data/task_database.dart';

/// Provides the few things the whole app shares: the logger and the database.
/// Everything else is created by the screen that needs it.
class const AppScope({
  super.key,
  required final Logger logger,

  /// True in tests: data lives in memory and disappears afterwards.
  required final bool inMemoryDatabase,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Logger>.value(value: logger),
        Provider<TaskDatabase>(
          create: (_) => inMemoryDatabase
              ? TaskDatabase.forTesting(NativeDatabase.memory())
              : TaskDatabase(),
          dispose: (_, db) => db.close(),
        ),
      ],
      child: child,
    );
  }
}
