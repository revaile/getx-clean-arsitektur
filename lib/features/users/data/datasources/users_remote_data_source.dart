import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user_request.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUser(int id);
  Future<UserModel> createUser(UserRequest request);
  Future<UserModel> updateUser(int id, UserRequest request);
  Future<void> deleteUser(int id);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  const UsersRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _apiClient.get(ApiConstants.users);

    if (response is! List) {
      return const [];
    }

    return response
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();
  }

  @override
  Future<UserModel> getUser(int id) async {
    final response = await _apiClient.get('${ApiConstants.users}/$id');
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserModel> createUser(UserRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.users,
      body: request.toJson(),
    );

    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserModel> updateUser(int id, UserRequest request) async {
    final response = await _apiClient.put(
      '${ApiConstants.users}/$id',
      body: request.toJson(),
    );

    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> deleteUser(int id) {
    return _apiClient.delete('${ApiConstants.users}/$id');
  }
}
