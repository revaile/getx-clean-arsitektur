import 'package:get/get.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos_usecase.dart';

class TodosController extends GetxController {
  TodosController(
    this._getTodosUseCase,
  );

  final GetTodosUseCase _getTodosUseCase;

  final todos = <TodoEntity>[].obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTodos();
  }

  Future<void> getTodos() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getTodosUseCase();

    result.fold(
      onFailure: (message) => errorMessage.value = message,
      onSuccess: (data) => todos.assignAll(data),
    );

    isLoading.value = false;
  }
}
