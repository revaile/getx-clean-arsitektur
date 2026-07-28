import 'package:getx_clean_arsitektur/features/posts/domain/entities/post_entity.dart';

import '../../../../core/utils/app_result.dart';

abstract class PostRepository {
  //ambil buat list post
  Future<AppResult<List<PostEntity>>> getPosts();

}
