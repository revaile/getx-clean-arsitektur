import '../../../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class GetUserUseCase {
  const GetUserUseCase(this._repository);

  final UsersRepository _repository;

  Future<AppResult<UserEntity>> call(int id) {
    return _repository.getUser(id);
  }
}
