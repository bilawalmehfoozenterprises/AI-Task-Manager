import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lifely/src/core/utils/context_extensions.dart';
import 'package:lifely/src/core/widgets/centered_loading.dart';
import 'package:lifely/src/features/task_editor/presentation/controller/task_editor_controller.dart';
import 'package:lifely/src/features/task_editor/presentation/widgets/task_editor_form.dart';

/// The editor page: a spinner while an existing task loads, then the form.
class const TaskEditorView({super.key, required final bool isEditing})
    extends SignalWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskEditorController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? context.loc.editTask : context.loc.addTask),
      ),
      body: SafeArea(
        child: controller.isLoading.value
            ? const CenteredLoading()
            : TaskEditorForm(original: controller.original.value),
      ),
    );
  }
}
