import '../../../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);

  final UsersRepository _repository;

  Future<AppResult<List<UserEntity>>> call() {
    return _repository.getUsers();
  }
}
