import '../../../../core/utils/app_result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todos_repository.dart';

class GetTodosUseCase {
  const GetTodosUseCase(this._repository);

  final TodosRepository _repository;

  Future<AppResult<List<TodoEntity>>> call() {
    return _repository.getTodos();
  }
}
