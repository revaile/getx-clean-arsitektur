import '../../../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../entities/user_request.dart';
import '../repositories/users_repository.dart';

class CreateUserUseCase {
  const CreateUserUseCase(this._repository);

  final UsersRepository _repository;

  Future<AppResult<UserEntity>> call(UserRequest request) {
    return _repository.createUser(request);
  }
}
