import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  const PostsRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _apiClient.get(ApiConstants.posts);

    if (response is! List) {
      return const [];
    }

    return response
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
  }
}
