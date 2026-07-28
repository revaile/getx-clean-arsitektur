import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_entity.dart' show TodoEntity;

import '../../../../core/utils/app_result.dart';

abstract class TodosRepository {
  Future<AppResult<List<TodoEntity>>> getTodos();
}
