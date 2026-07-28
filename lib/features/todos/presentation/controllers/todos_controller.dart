import 'package:get/get.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/usecases/get_todo_usecase.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos_usecase.dart';

class TodosController extends GetxController {
  TodosController(
    //get list
    this._getTodosUseCase,
    // get by id
    this._getTodoUseCase,
  );

  final GetTodosUseCase _getTodosUseCase;
  // get by id
  final GetTodoUsecase _getTodoUseCase;

  final todos = <TodoEntity>[].obs;
  final selectedTodo = Rxn<TodoEntity>();

  final isLoading = false.obs;
  final isDetailLoading = false.obs;


  final errorMessage = ''.obs;
  final detailErrorMessage = ''.obs;



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

  // buat get by id
    Future<void> getTodo(int id) async {
    isDetailLoading.value = true;
    selectedTodo.value = null;

    final result = await _getTodoUseCase(id);

    result.fold(
      onFailure: (message) => detailErrorMessage.value = message,
      onSuccess: (data) => selectedTodo.value = data,
    );

    isDetailLoading.value = false;
  }


}
