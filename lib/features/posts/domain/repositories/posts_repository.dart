import '../../../../core/utils/app_result.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<AppResult<List<PostEntity>>> getPosts();
}
