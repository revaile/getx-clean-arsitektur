import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/entities/post_entity.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/usecase/get_post_usecase.dart';

class PostsControllers extends GetxController {
  PostsControllers(
    //untuk list post
    this._getPostsUseCase,

  );
  final GetPostUsecase _getPostsUseCase;

  final posts = <PostEntity>[].obs;
  final errorMessage = ''.obs;
  final isLoading = false.obs;

    @override
  void onInit() {
    super.onInit();
    getPosts();
  }

  // ========= LOGIKA UNTUK LIST POST =========
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