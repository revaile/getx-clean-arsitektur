import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/users_remote_data_source.dart';
import '../../data/repositories/users_repository_impl.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../controllers/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersRemoteDataSource>(
      () => UsersRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<UsersRepository>(
      () => UsersRepositoryImpl(Get.find<UsersRemoteDataSource>()),
    );
    Get.lazyPut(() => GetUsersUseCase(Get.find<UsersRepository>()));
    Get.lazyPut(() => GetUserUseCase(Get.find<UsersRepository>()));
    Get.lazyPut(() => CreateUserUseCase(Get.find<UsersRepository>()));
    Get.lazyPut(() => UpdateUserUseCase(Get.find<UsersRepository>()));
    Get.lazyPut(() => DeleteUserUseCase(Get.find<UsersRepository>()));
    Get.lazyPut(
      () => UsersController(
        Get.find<GetUsersUseCase>(),
        Get.find<GetUserUseCase>(),
        Get.find<CreateUserUseCase>(),
        Get.find<UpdateUserUseCase>(),
        Get.find<DeleteUserUseCase>(),
      ),
    );
  }
}
