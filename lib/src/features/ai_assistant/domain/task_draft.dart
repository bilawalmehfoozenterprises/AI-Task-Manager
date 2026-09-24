import 'package:equatable/equatable.dart';

/// A task the AI suggested, waiting for the user to confirm it.
class const TaskDraft({
  required final String title,
  required final String description,
  required final DateTime deadline,
}) extends Equatable {
  /// Reads `{title, description, deadline: "YYYY-MM-DD"}`.
  /// Returns null when the title or deadline is missing or invalid.
  static TaskDraft? fromJson(Map<String, Object?> json) {
    final title = json['title'];
    final description = json['description'];
    final deadline = json['deadline'];
    final date = deadline is String ? DateTime.tryParse(deadline) : null;
    if (title is! String || title.trim().isEmpty || date == null) return null;
    return TaskDraft(
      title: title.trim(),
      description: description is String ? description.trim() : '',
      deadline: date,
    );
  }

  @override
  List<Object?> get props => [title, description, deadline];
}
