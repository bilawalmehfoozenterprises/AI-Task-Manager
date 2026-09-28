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
  String get myTasks => 'My Tasks';

  @override
  String get noTasksFound => 'No tasks yet';

  @override
  String get pendingTab => 'Pending';

  @override
  String get completedTab => 'Completed';

  @override
  String get noCompletedTasks => 'No completed tasks yet';

  @override
  String get deadline => 'Deadline:';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get save => 'Save';

  @override
  String get notChosen => 'Not chosen';

  @override
  String get emptyTitle => 'Please enter a title.';

  @override
  String get emptyDescription => 'Please enter a description.';

  @override
  String get missingDeadline => 'Please pick a deadline.';

  @override
  String get saveTaskFailed => 'Couldn\'t save the task. Please try again.';

  @override
  String get taskNotFound => 'This task no longer exists.';

  @override
  String get loadTasksFailed => 'Couldn\'t load your tasks.';

  @override
  String get deleteTaskTitle => 'Delete task?';

  @override
  String get deleteTaskBody => 'Are you sure you want to delete this task?';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get error => 'Error';

  @override
  String get aiAssistantTitle => 'AI Assistant';

  @override
  String get aiInputHint => 'Type your task here';

  @override
  String get confirmTaskTitle => 'Confirm Task';

  @override
  String get aiDraftReady => 'I\'ve drafted a task. Please confirm to save it.';

  @override
  String get aiTaskSaved => 'Task saved.';

  @override
  String get aiBusy =>
      'The AI is busy right now. Please try again in a moment.';

  @override
  String get aiUnavailable => 'The AI isn\'t available right now.';

  @override
  String get aiInvalidReply =>
      'Sorry, I didn\'t understand that. Please try rephrasing.';

  @override
  String get voiceUnavailable => 'Voice input isn\'t available.';
}
