import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/src/app.dart';
import 'package:todo_app/src/features/todo_list/data/app_database.dart';
import 'package:todo_app/src/features/todo_list/data/drift_repository.dart';
import 'package:todo_app/src/features/todo_list/domain/todo_repository.dart';
import 'package:todo_app/src/features/todo_list/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/src/utils/app_logger.dart';

final sl = GetIt.instance;

/// Robot for widget testing that sets up Drift + BLoC.
class Robot {
  final WidgetTester tester;
  late final AppDatabase _db;
  late final TodoRepository _repository;

  Robot(this.tester);

  Future<void> setupFakeLocator() async {
    sl.reset();

    _db = AppDatabase.forTesting(NativeDatabase.memory());
    _repository = DriftRepository(_db);

    sl.registerLazySingleton<Logger>(() => AppLogger());
    sl.registerLazySingleton<TodoRepository>(() => _repository);
  }

  Future<void> pumpMyApp() async {
    final logger = sl<Logger>();
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => TodoCubit(_repository, logger)),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();
  }
}
