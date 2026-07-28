import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:getx_clean_arsitektur/core/network/api_client.dart';
import 'package:getx_clean_arsitektur/features/todos/data/datasources/todos_remote_data_source.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/repositories/todos_repository.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/repositories/todos_repository_impl.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/usecases/get_todos_usecase.dart';
import 'package:getx_clean_arsitektur/features/todos/presentation/controllers/todos_controller.dart';

class TodosBinding extends Bindings {
  @override
  void dependencies() {
    //darftarkan remote data source
    Get.lazyPut<TodosRemoteDataSource>(
      () => TodosRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    //darftarkan repository
    Get.lazyPut<TodosRepository>(
      () => TodosRepositoryImpl(Get.find<TodosRemoteDataSource>()),
    );  
    //darftarkan usecase
    Get.lazyPut(
      () => GetTodosUseCase(Get.find<TodosRepository>()));
      //darftarkan controller
    Get.lazyPut(
      () => TodosController(Get.find<GetTodosUseCase>()),
    );
  }
}