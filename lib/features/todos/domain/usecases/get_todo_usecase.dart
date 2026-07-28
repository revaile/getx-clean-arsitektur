import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_entity.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/repositories/todos_repository.dart';

import '../../../../core/utils/app_result.dart';

class GetTodoUsecase {
  const GetTodoUsecase(this._repository);

  final TodosRepository _repository;

  Future<AppResult<TodoEntity>> call(int id) {
    return _repository.getTodo(id);
  }
}
