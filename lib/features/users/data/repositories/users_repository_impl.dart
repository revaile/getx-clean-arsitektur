import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_request.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_remote_data_source.dart';

class UsersRepositoryImpl implements UsersRepository {
  const UsersRepositoryImpl(this._remoteDataSource);

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<UserEntity>>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return AppSuccess(users);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }

  @override
  Future<AppResult<UserEntity>> getUser(int id) async {
    try {
      final user = await _remoteDataSource.getUser(id);
      return AppSuccess(user);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }

  @override
  Future<AppResult<UserEntity>> createUser(UserRequest request) async {
    try {
      final user = await _remoteDataSource.createUser(request);
      return AppSuccess(user);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }

  @override
  Future<AppResult<UserEntity>> updateUser(int id, UserRequest request) async {
    try {
      final user = await _remoteDataSource.updateUser(id, request);
      return AppSuccess(user);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }

  @override
  Future<AppResult<void>> deleteUser(int id) async {
    try {
      await _remoteDataSource.deleteUser(id);
      return const AppSuccess<void>(null);
    } on ServerException catch (error) {
      return AppFailure(error.message);
    } catch (error) {
      return AppFailure('Terjadi kesalahan: $error');
    }
  }
}
