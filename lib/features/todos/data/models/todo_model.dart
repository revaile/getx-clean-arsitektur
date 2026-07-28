import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
    const TodoModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.dueOn,
    required super.status,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['user_id'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '-',
      dueOn: json['due_on'] as DateTime? ?? DateTime.now(),
      status: json['status'] as bool? ?? false,
    );
  }

}