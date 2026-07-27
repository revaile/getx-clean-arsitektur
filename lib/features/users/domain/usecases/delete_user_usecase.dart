import '../../../../core/utils/app_result.dart';
import '../repositories/users_repository.dart';

class DeleteUserUseCase {
  const DeleteUserUseCase(this._repository);

  final UsersRepository _repository;

  Future<AppResult<void>> call(int id) {
    return _repository.deleteUser(id);
  }
}
