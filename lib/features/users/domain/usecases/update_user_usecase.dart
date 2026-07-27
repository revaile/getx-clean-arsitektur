import '../../../../core/utils/app_result.dart';
import '../entities/user_entity.dart';
import '../entities/user_request.dart';
import '../repositories/users_repository.dart';

class UpdateUserUseCase {
  const UpdateUserUseCase(this._repository);

  final UsersRepository _repository;

  Future<AppResult<UserEntity>> call(int id, UserRequest request) {
    return _repository.updateUser(id, request);
  }
}
