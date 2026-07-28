import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/posts_remote_data_source.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../controllers/posts_controller.dart';

class PostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<PostsRepository>(
      () => PostsRepositoryImpl(Get.find<PostsRemoteDataSource>()),
    );
    Get.lazyPut(() => GetPostsUseCase(Get.find<PostsRepository>()));
    Get.lazyPut(
      () => PostsController(Get.find<GetPostsUseCase>()),
    );
  }
}
