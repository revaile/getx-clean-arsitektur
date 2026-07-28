import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todos_controller.dart';

class TodoFormSheet extends GetView<TodosController> {
  const TodoFormSheet({super.key});

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
                'Create Todo',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'User ID wajib diisi';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'User ID harus angka';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title wajib diisi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.dueOnController,
                decoration: const InputDecoration(
                  labelText: 'Due On',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Due On wajib diisi';
                  }

                  return null;
                },
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
                    DropdownMenuItem(
                      value: 'pending',
                      child: Text('pending'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('completed'),
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
                          final isSuccess = await controller.createTodo();

                          if (isSuccess) {
                            Get.back<void>();
                          }
                        },
                  icon: controller.isSubmitting.value
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: const Text('Create Todo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}