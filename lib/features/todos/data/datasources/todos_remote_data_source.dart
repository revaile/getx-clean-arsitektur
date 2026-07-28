import 'package:getx_clean_arsitektur/core/constants/api_constants.dart';
import 'package:getx_clean_arsitektur/core/network/api_client.dart';
import 'package:getx_clean_arsitektur/features/todos/data/models/todo_model.dart';

abstract class TodosRemoteDataSource {
  Future<List<TodoModel>> getTodos();
}

class TodosRemoteDataSourceImpl implements TodosRemoteDataSource {
  const TodosRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

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
}
