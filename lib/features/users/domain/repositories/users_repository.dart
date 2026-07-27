import '../../../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../entities/user_request.dart';

abstract class UsersRepository {
  Future<AppResult<List<UserEntity>>> getUsers();
  Future<AppResult<UserEntity>> getUser(int id);
  Future<AppResult<UserEntity>> createUser(UserRequest request);
  Future<AppResult<UserEntity>> updateUser(int id, UserRequest request);
  Future<AppResult<void>> deleteUser(int id);
}
