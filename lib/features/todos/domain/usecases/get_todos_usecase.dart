import 'package:getx_clean_arsitektur/core/utils/app_result.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_entity.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/repositories/todos_repository.dart';

class GetTodosUseCase {
  const GetTodosUseCase(this._repository);

  final TodosRepository _repository;

  Future<AppResult<List<TodoEntity>>> call() {
    return _repository.getTodos();
  }
}
