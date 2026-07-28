import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_arsitektur/features/todos/presentation/pages/todos_detail_pages.dart';

import '../controllers/todos_controller.dart';
import '../widgets/todo_form_sheet.dart';

class TodosPage extends GetView<TodosController> {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.getTodos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.todos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (controller.todos.isEmpty) {
            return const Center(child: Text('Todo kosong'));
          }

          return RefreshIndicator(
            onRefresh: controller.getTodos,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.todos.length,
              itemBuilder: (context, index) {
                final todo = controller.todos[index];

                return InkWell(
                  onTap: () => Get.to(() => TodosDetailPage(todoId: todo.id)),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          _TodoRow(label: 'ID', value: todo.id.toString()),
                          _TodoRow(
                            label: 'User ID',
                            value: todo.userId.toString(),
                          ),
                          _TodoRow(label: 'Due On', value: todo.dueOn),
                          _TodoRow(label: 'Status', value: todo.status),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.prepareCreateForm();

          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (_) => const TodoFormSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Todo'),
      ),
    );
  }
}

class _TodoRow extends StatelessWidget {
  const _TodoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
