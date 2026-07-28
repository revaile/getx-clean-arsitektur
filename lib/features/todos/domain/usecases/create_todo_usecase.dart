import 'package:getx_clean_arsitektur/core/utils/app_result.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_entity.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_request.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/repositories/todos_repository.dart';

class CreateTodoUseCase {
  const CreateTodoUseCase(this._repository);

  final TodosRepository _repository;

  Future<AppResult<TodoEntity>> call(int userId, TodoRequest request) {
    return _repository.createTodo(userId, request);
  }
}
