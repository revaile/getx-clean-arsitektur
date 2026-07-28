import '../../../../core/utils/app_result.dart';
import '../entities/todo_entity.dart';
import '../entities/todo_request.dart';

abstract class TodosRepository {
  Future<AppResult<List<TodoEntity>>> getTodos();
  Future<AppResult<TodoEntity>> getTodo(int id);
  Future<AppResult<TodoEntity>> createUser(int userId, TodoRequest request);

}
