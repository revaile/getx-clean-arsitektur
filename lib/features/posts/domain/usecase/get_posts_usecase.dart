import 'package:getx_clean_arsitektur/core/utils/app_result.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/entities/post_entity.dart';
import 'package:getx_clean_arsitektur/features/posts/domain/repositories/posts_repository.dart';

class GetPostsUseCase {
    const GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  Future<AppResult<List<PostEntity>>> call() {
    return _repository.getPosts();
  }
}