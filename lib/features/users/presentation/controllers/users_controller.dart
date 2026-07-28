import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_request.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';

class UsersController extends GetxController {
  UsersController(
    this._getUsersUseCase,
    this._getUserUseCase,
    this._createUserUseCase,
    this._updateUserUseCase,
    this._deleteUserUseCase,
  );

  final GetUsersUseCase _getUsersUseCase;
  final GetUserUseCase _getUserUseCase;
  final CreateUserUseCase _createUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  final users = <UserEntity>[].obs;
  final selectedUser = Rxn<UserEntity>();
  final errorMessage = ''.obs;
  final isLoading = false.obs;
  final isDetailLoading = false.obs;
  final isSubmitting = false.obs;
  final isDeleting = false.obs;
  final selectedGender = 'male'.obs;
  final selectedStatus = 'active'.obs;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  Future<void> getUsers() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getUsersUseCase();

    result.fold(
      onFailure: (message) => errorMessage.value = message,
      onSuccess: (data) => users.assignAll(data),
    );

    isLoading.value = false;
  }

  Future<void> getUser(int id) async {
    isDetailLoading.value = true;
    selectedUser.value = null;

    final result = await _getUserUseCase(id);

    result.fold(
      onFailure: (message) => errorMessage.value = message,
      onSuccess: (data) => selectedUser.value = data,
    );

    isDetailLoading.value = false;
  }

  void prepareCreateForm() {
    nameController.text = 'Tenali Ramakrishna';
    emailController.text = 'tenali${DateTime.now().millisecondsSinceEpoch}@example.com';
    selectedGender.value = 'male';
    selectedStatus.value = 'active';
  }

  void prepareEditForm(UserEntity user) {
    nameController.text = user.name;
    emailController.text = user.email;
    selectedGender.value = user.gender;
    selectedStatus.value = user.status;
  }

  Future<bool> createUser() async {
    if (formKey.currentState?.validate() != true) {
      return false;
    }

    isSubmitting.value = true;
    final result = await _createUserUseCase(_formRequest());

    final isSuccess = result.fold(
      onFailure: (message) {
        _showError(message);
        return false;
      },
      onSuccess: (user) {
        users.insert(0, user);
        _showSuccess('User berhasil dibuat');
        return true;
      },
    );

    isSubmitting.value = false;
    return isSuccess;
  }

  Future<bool> updateUser(UserEntity user) async {
    if (formKey.currentState?.validate() != true) {
      return false;
    }

    isSubmitting.value = true;
    final result = await _updateUserUseCase(user.id, _formRequest());

    final isSuccess = result.fold(
      onFailure: (message) {
        _showError(message);
        return false;
      },
      onSuccess: (updatedUser) {
        final index = users.indexWhere((item) => item.id == updatedUser.id);
        if (index >= 0) {
          users[index] = updatedUser;
        }
        selectedUser.value = updatedUser;
        _showSuccess('User berhasil diupdate');
        return true;
      },
    );

    isSubmitting.value = false;
    return isSuccess;
  }

  Future<void> deleteUser(UserEntity user) async {
    isDeleting.value = true;
    final result = await _deleteUserUseCase(user.id);

    result.fold(
      onFailure: _showError,
      onSuccess: (_) {
        users.removeWhere((item) => item.id == user.id);
        selectedUser.value = null;
        _showSuccess('User berhasil dihapus');
      },
    );

    isDeleting.value = false;
  }

  UserRequest _formRequest() {
    return UserRequest(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      gender: selectedGender.value,
      status: selectedStatus.value,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar('Berhasil', message, snackPosition: SnackPosition.BOTTOM);
  }

  void _showError(String message) {
    Get.snackbar('Gagal', message, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
