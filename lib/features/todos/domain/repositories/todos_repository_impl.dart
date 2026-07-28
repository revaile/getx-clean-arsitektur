import 'package:getx_clean_arsitektur/core/errors/exceptions.dart';
import 'package:getx_clean_arsitektur/core/utils/app_result.dart';
import 'package:getx_clean_arsitektur/features/todos/data/datasources/todos_remote_data_source.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_entity.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/repositories/todos_repository.dart';

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
}
