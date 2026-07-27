import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../controllers/users_controller.dart';

class UserFormSheet extends GetView<UsersController> {
  const UserFormSheet({super.key, this.user});

  final UserEntity? user;

  bool get _isEdit => user != null;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEdit ? 'Edit User' : 'Create User',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name wajib diisi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!GetUtils.isEmail(email)) {
                    return 'Format email tidak valid';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedGender.value,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('male')),
                    DropdownMenuItem(value: 'female', child: Text('female')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedGender.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedStatus.value,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('active')),
                    DropdownMenuItem(
                      value: 'inactive',
                      child: Text('inactive'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedStatus.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => FilledButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async {
                          final isSuccess = _isEdit
                              ? await controller.updateUser(user!)
                              : await controller.createUser();
                          if (isSuccess) {
                            Get.back<void>();
                          }
                        },
                  icon: controller.isSubmitting.value
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(_isEdit ? Icons.save_outlined : Icons.add),
                  label: Text(_isEdit ? 'Simpan' : 'Create User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
