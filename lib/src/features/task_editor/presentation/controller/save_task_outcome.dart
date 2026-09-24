import 'package:lifely/src/features/task_editor/domain/task_form_error.dart';

/// What happened when the user pressed Save.
sealed class const SaveTaskOutcome();

class const TaskSaved() extends SaveTaskOutcome;

class const TaskFormInvalid(final TaskFormError error) extends SaveTaskOutcome;

class const TaskSaveFailed() extends SaveTaskOutcome;
