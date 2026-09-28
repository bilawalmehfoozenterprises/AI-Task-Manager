import 'package:equatable/equatable.dart';

/// A single task. Immutable: use [copyWith] to change it.
class const Task({
  required final int id,
  required final String title,
  required final String description,
  required final DateTime deadline,
  final bool isCompleted = false,
}) extends Equatable {
  Task copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, deadline, isCompleted];
}
