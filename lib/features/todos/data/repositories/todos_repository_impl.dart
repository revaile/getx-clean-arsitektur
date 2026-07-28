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
}
