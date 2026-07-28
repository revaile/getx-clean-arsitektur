import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_request.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/usecases/create_todo_usecase.dart';
import 'package:getx_clean_arsitektur/features/todos/domain/usecases/get_todo_usecase.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos_usecase.dart';

class TodosController extends GetxController {
  TodosController(
    //get list
    this._getTodosUseCase,
    // get by id
    this._getTodoUseCase,
    // create todo
    this._createTodoUseCase,
  );

  final GetTodosUseCase _getTodosUseCase;
  // get by id
  final GetTodoUseCase _getTodoUseCase;
  // create todo
  final CreateTodoUseCase _createTodoUseCase;

  final todos = <TodoEntity>[].obs;
  final selectedTodo = Rxn<TodoEntity>();

  final isLoading = false.obs;
  final isDetailLoading = false.obs;

  final errorMessage = ''.obs;
  final detailErrorMessage = ''.obs;

  //kebutuhan create
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final titleController = TextEditingController();
  final dueOnController = TextEditingController();
  final selectedStatus = 'pending'.obs;
  final isSubmitting = false.obs;

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

  //buat crete todo
  //pengisi otomatis
  void prepareCreateForm() {
    userIdController.text = '8560408';
    titleController.text = 'amarnyoooooo';
    dueOnController.text = '2026-08-15T00:00:00.000+05:30';
    selectedStatus.value = 'pending';
  }

  //Method untuk create todo
  Future<bool> createTodo() async {
    if (formKey.currentState?.validate() != true) {
      return false;
    }

  //beda disini
    final userId = int.tryParse(userIdController.text.trim());
    if (userId == null) {
      _showError('User ID tidak valid');
      return false;
    }

    isSubmitting.value = true;

    final request = TodoRequest(
      title: titleController.text.trim(),
      dueOn: dueOnController.text.trim(),
      status: selectedStatus.value,
    );
    final result = await _createTodoUseCase(userId, request);

    final isSuccess = result.fold(
      onFailure: (message) {
        _showError(message);
        return false;
      },
      onSuccess: (todo) {
        todos.insert(0, todo);
        _showSuccess('Todo berhasil dibuat');
        return true;
      },
    );

    isSubmitting.value = false;
    return isSuccess;
  }

  void _showSuccess(String message) {
    Get.snackbar('Berhasil', message, snackPosition: SnackPosition.BOTTOM);
  }

  void _showError(String message) {
    Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
  }

  //kepentingan create todo
  @override
  void onClose() {
  userIdController.dispose();
  titleController.dispose();
  dueOnController.dispose();
  super.onClose();
}
}
