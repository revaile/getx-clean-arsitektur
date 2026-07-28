import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../controllers/users_controller.dart';
import '../widgets/user_card.dart';
import '../widgets/user_form_sheet.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.getUsers,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        icon: const Icon(Icons.add),
        label: const Text('User'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return _ErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.getUsers,
            );
          }

          if (controller.users.isEmpty) {
            return _EmptyView(onRefresh: controller.getUsers);
          }

          return RefreshIndicator(
            onRefresh: controller.getUsers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];

                return UserCard(
                  user: user,
                  onTap: () => _showDetail(context, user.id),
                  onEdit: () => _showForm(context, user: user),
                  onDelete: () => _confirmDelete(context, user),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _showForm(BuildContext context, {UserEntity? user}) {
    if (user == null) {
      controller.prepareCreateForm();
    } else {
      controller.prepareEditForm(user);
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => UserFormSheet(user: user),
    );
  }

  void _showDetail(BuildContext context, int id) {
    controller.getUser(id);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Obx(() {
          if (controller.isDetailLoading.value) {
            return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = controller.selectedUser.value;
          if (user == null) {
            return const SizedBox(
              height: 160,
              child: Center(child: Text('User tidak ditemukan')),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'User #${user.id}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Name', value: user.name),
                _DetailRow(label: 'Email', value: user.email),
                _DetailRow(label: 'Gender', value: user.gender),
                _DetailRow(label: 'Status', value: user.status),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.back<void>();
                          _showForm(context, user: user);
                        },
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                        ),
                        onPressed: () {
                          Get.back<void>();
                          _confirmDelete(context, user);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _confirmDelete(BuildContext context, UserEntity user) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Hapus ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Batal'),
          ),
          Obx(
            () => FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              onPressed: controller.isDeleting.value
                  ? null
                  : () async {
                      await controller.deleteUser(user);
                      Get.back<void>();
                    },
              icon: controller.isDeleting.value
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

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
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF64748B),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        onPressed: onRefresh,
        icon: const Icon(Icons.refresh),
        label: const Text('Muat Users'),
      ),
    );
  }
}
