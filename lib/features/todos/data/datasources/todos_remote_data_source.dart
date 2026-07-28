import 'package:getx_clean_arsitektur/features/todos/domain/entities/todo_request.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/todo_model.dart';

abstract class TodosRemoteDataSource {
  // abstrak buat list
  Future<List<TodoModel>> getTodos();
  // abstrak buat get by id
  Future<TodoModel> getTodo(int id);
  //abstrak buat create
   Future<TodoModel> createTodo(TodoRequest request);

}

class TodosRemoteDataSourceImpl implements TodosRemoteDataSource {
  const TodosRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  //untuk list

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await _apiClient.get(ApiConstants.todos);

    if (response is! List) {
      return const [];
    }

    return response
        .whereType<Map<String, dynamic>>()
        .map(TodoModel.fromJson)
        .toList();
  }

  //untuk get by id
    @override
    Future<TodoModel> getTodo(int id) async {
    final response = await _apiClient.get('${ApiConstants.todos}/$id');
    return TodoModel.fromJson(response as Map<String, dynamic>);
  }

  // untuk create
    @override
  Future<TodoModel> createTodo(TodoRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.todos,
      body: request.toJson(),
    );

    return TodoModel.fromJson(response as Map<String, dynamic>);
  }



}
