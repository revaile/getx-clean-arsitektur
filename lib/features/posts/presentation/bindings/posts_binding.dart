import 'package:get/get.dart';
import 'package:getx_clean_arsitektur/core/network/api_client.dart';
import 'package:getx_clean_arsitektur/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/repositories/posts_repository.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/repositories/posts_repository_impl.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/usecase/get_posts_usecase.dart';
import 'package:getx_clean_arsitektur/features/posts/presentation/controllers/posts_controllers.dart';



class PostsBinding extends Bindings {
  @override
  void dependencies() {
    //daftarkan remote data source
    Get.lazyPut<PostsRemoteDataSource>(
      //implementasi dari remote data source
      () => PostsRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    //daftarkan repository dan implementasinya
    Get.lazyPut<PostsRepository>(
      //implementasi dari repository
      () => PostsRepositoryImpl(Get.find<PostsRemoteDataSource>()),
    );
    //daftarkan usecase
    Get.lazyPut(
      () => GetPostsUseCase(Get.find<PostsRepository>()));
    // Get.lazyPut(() => GetPostUseCase(Get.find<PostsRepository>()));
    // Get.lazyPut(() => CreatePostUseCase(Get.find<PostsRepository>()));
    // Get.lazyPut(() => UpdatePostUseCase(Get.find<PostsRepository>()));
    // Get.lazyPut(() => DeletePostUseCase(Get.find<PostsRepository>()));
    Get.lazyPut(
      () => PostsController(
        Get.find<GetPostsUseCase>(),
        // Get.find<GetPostUseCase>(),
        // Get.find<CreatePostUseCase>(),
        // Get.find<UpdatePostUseCase>(),
        // Get.find<DeletePostUseCase>(),
      ),
    );
  }
}
