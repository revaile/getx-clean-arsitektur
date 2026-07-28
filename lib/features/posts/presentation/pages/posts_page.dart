import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_clean_arsitektur/features/posts/presentation/controllers/posts_controllers.dart';


class PostsPage extends GetView<PostsController> {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.getPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.posts.isEmpty) {
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

          if (controller.posts.isEmpty) {
            return const Center(child: Text('Post kosong'));
          }

          return RefreshIndicator(
            onRefresh: controller.getPosts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.posts.length,
              itemBuilder: (context, index) {
                final post = controller.posts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(post.body),
                    ),
                    trailing: Text('#${post.id}'),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}