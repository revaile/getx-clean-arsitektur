import 'package:get/get.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/usecases/get_todo_usecase.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/todos_remote_data_source.dart';
import '../../data/repositories/todos_repository_impl.dart';
import '../../domain/repositories/todos_repository.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../controllers/todos_controller.dart';

class TodosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodosRemoteDataSource>(
      () => TodosRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<TodosRepository>(
      () => TodosRepositoryImpl(Get.find<TodosRemoteDataSource>()),
    );
    Get.lazyPut(() => GetTodosUseCase(Get.find<TodosRepository>()));
    Get.lazyPut(() => GetTodoUseCase(Get.find<TodosRepository>()));
    Get.lazyPut(
      () => TodosController(
        Get.find<GetTodosUseCase>(),
        Get.find<GetTodoUseCase>()
        
        ),
    );
  }
}
