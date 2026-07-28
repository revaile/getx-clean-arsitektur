import '../../../../core/utils/app_result.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  const GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  Future<AppResult<List<PostEntity>>> call() {
    return _repository.getPosts();
  }
}
