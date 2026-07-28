import 'package:get/get.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';

class PostsController extends GetxController {
  PostsController(
    this._getPostsUseCase,
  );

  final GetPostsUseCase _getPostsUseCase;

  final posts = <PostEntity>[].obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPosts();
  }

  Future<void> getPosts() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getPostsUseCase();

    result.fold(
      onFailure: (message) => errorMessage.value = message,
      onSuccess: (data) => posts.assignAll(data),
    );

    isLoading.value = false;
  }
}
