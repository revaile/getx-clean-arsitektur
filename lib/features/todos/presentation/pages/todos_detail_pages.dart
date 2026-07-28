import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todos_controller.dart';

class TodosDetailPage extends StatefulWidget {
  const TodosDetailPage({super.key, required this.todoId});

  final int todoId;

  @override
  State<TodosDetailPage> createState() => _TodosDetailPageState();
}

class _TodosDetailPageState extends State<TodosDetailPage> {
  final TodosController controller = Get.find<TodosController>();

  @override
  void initState() {
    super.initState();
    controller.getTodo(widget.todoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo #${widget.todoId}'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.detailErrorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.detailErrorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => controller.getTodo(widget.todoId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final todo = controller.selectedTodo.value;

          if (todo == null) {
            return const Center(child: Text('Todo tidak ditemukan'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'ID', value: todo.id.toString()),
                      _DetailRow(
                        label: 'User ID',
                        value: todo.userId.toString(),
                      ),
                      _DetailRow(label: 'Due On', value: todo.dueOn),
                      _DetailRow(label: 'Status', value: todo.status),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}