// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Lifely';

  @override
  String get myTodos => 'My Todos';

  @override
  String get deadline => 'Deadline:';

  @override
  String get noTodoFound => 'No task found';

  @override
  String get addTodo => 'Add Todo';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get save => 'Save';

  @override
  String get emptyTitleDesc => 'Title or description is empty.';

  @override
  String get notChoosed => 'not choosed';

  @override
  String get notPickedDeadline => 'Deadline is empty.';

  @override
  String get todoDelete => 'Todo Delete!';

  @override
  String get deleteTodoBody => 'Are you sure you want to delete this todo.';

  @override
  String get completedTodos => 'Completed Todos';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get editTodo => 'Edit Todo';

  @override
  String get aiTaskInputTitle => 'AI Task Input';

  @override
  String get aiInputHint => 'Type your task here';

  @override
  String get submitButton => 'Submit';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get error => 'Error';

  @override
  String get confirmTaskTitle => 'Confirm Task';
}
