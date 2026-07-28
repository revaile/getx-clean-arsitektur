import 'package:getx_clean_arsitektur/core/constants/api_constants.dart';
import 'package:getx_clean_arsitektur/core/network/api_client.dart';
import 'package:getx_clean_arsitektur/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  //ambil buat list post
  Future<List<PostModel>> getPosts();

}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  const PostRemoteDataSourceImpl(this._apiClient);

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

  // @override
  // Future<PostModel> getUser(int id) async {
  //   final response = await _apiClient.get('${ApiConstants.users}/$id');
  //   return PostModel.fromJson(response as Map<String, dynamic>);
  // }

  // @override
  // Future<PostModel> createUser(UserRequest request) async {
  //   final response = await _apiClient.post(
  //     ApiConstants.users,
  //     body: request.toJson(),
  //   );

  //   return PostModel.fromJson(response as Map<String, dynamic>);
  // }

  // @override
  // Future<PostModel> updateUser(int id, UserRequest request) async {
  //   final response = await _apiClient.put(
  //     '${ApiConstants.users}/$id',
  //     body: request.toJson(),
  //   );

  //   return PostModel.fromJson(response as Map<String, dynamic>);
  // }

  // @override
  // Future<void> deleteUser(int id) {
  //   return _apiClient.delete('${ApiConstants.users}/$id');
  // }
}

