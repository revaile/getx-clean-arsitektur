import 'package:getx_clean_arsitektur/features/posts/domain/entities/post_entity.dart';

import '../../../../core/utils/app_result.dart';

abstract class PostsRepository {
  //ambil buat list post
  Future<AppResult<List<PostEntity>>> getPosts();

}
