import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_request.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todos_repository.dart';
import '../datasources/todos_remote_data_source.dart';

class TodosRepositoryImpl implements TodosRepository {
  const TodosRepositoryImpl(this._remoteDataSource);

  final TodosRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<TodoEntity>>> getTodos() async {
    try {
      final todos = await _remoteDataSource.getTodos();
      return AppSuccess(todos);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
    
  }

  // buat get by id
    @override
  Future<AppResult<TodoEntity>> getTodo(int id) async {
    try {
      final todo = await _remoteDataSource.getTodo(id);
      return AppSuccess(todo);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }

  // buat create todo
  @override
  Future<AppResult<TodoEntity>>createTodo(int userId, TodoRequest request) async {
    try {
      final todo = await _remoteDataSource.createTodo(userId, request);
      return AppSuccess(todo);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }


}
