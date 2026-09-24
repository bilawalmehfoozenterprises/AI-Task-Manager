import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:lifely/src/shared/task/data/task_table.dart';

part 'task_database.g.dart';

/// The on-device SQLite database that stores tasks.
@DriftDatabase(tables: [Tasks])
class TaskDatabase extends _$TaskDatabase {
  new() : super(_openConnection());

  new forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
