import 'package:drift/drift.dart';

/// The tasks table. Named `todos` (with a `name` column) so tasks saved by
/// older versions of the app are kept.
@DataClassName('TaskRow')
class Tasks extends Table {
  @override
  String get tableName => 'todos';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().named('name').withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get deadline => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
