import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/constants/app_sizes.dart';
import 'package:lifely/src/core/layout/window_size_class.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/error_dialog.dart';
import 'package:lifely/src/features/task_editor/presentation/controller/save_task_outcome.dart';
import 'package:lifely/src/features/task_editor/presentation/controller/task_editor_controller.dart';
import 'package:lifely/src/features/task_editor/presentation/widgets/deadline_field.dart';
import 'package:lifely/src/features/task_editor/presentation/widgets/task_form_error_text.dart';
import 'package:lifely/src/shared/task/domain/task.dart';

const kTaskTitleKey = ValueKey('Task-Title');
const kTaskDescriptionKey = ValueKey('Task-Description');
const kSaveTaskKey = ValueKey('Save-Task');

/// Title and description fields, the deadline picker, and the Save button.
class const TaskEditorForm({super.key, final Task? original})
    extends StatefulWidget {
  @override
  State<TaskEditorForm> createState() => _TaskEditorFormState();
}

class _TaskEditorFormState extends State<TaskEditorForm> {
  late final _title = TextEditingController(text: widget.original?.title);
  late final _description = TextEditingController(
    text: widget.original?.description,
  );

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskEditorController>();
    return SingleChildScrollView(
      padding: .all(context.windowSizeClass.margin),
      child: Column(
        spacing: Sizes.p16,
        crossAxisAlignment: .stretch,
        children: [
          Column(
            spacing: Sizes.p8,
            crossAxisAlignment: .stretch,
            children: [
              TextField(
                key: kTaskTitleKey,
                controller: _title,
                decoration: InputDecoration(labelText: context.loc.title),
              ),
              TextField(
                key: kTaskDescriptionKey,
                controller: _description,
                maxLines: 8,
                maxLength: 1000,
                decoration: InputDecoration(hintText: context.loc.description),
              ),
            ],
          ),
          const DeadlineField(),
          SignalBuilder(
            builder: (context) => FilledButton(
              key: kSaveTaskKey,
              onPressed: controller.isSaving.value ? null : _save,
              child: Text(context.loc.save),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final outcome = await context.read<TaskEditorController>().save(
      title: _title.text,
      description: _description.text,
    );
    if (!mounted) return;
    switch (outcome) {
      case TaskSaved():
        context.pop();
      case TaskFormInvalid(:final error):
        showErrorDialog(context: context, message: error.message(context.loc));
      case TaskSaveFailed():
        showErrorDialog(context: context, message: context.loc.saveTaskFailed);
    }
  }
}
