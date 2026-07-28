class ApiConstants {
  const ApiConstants._();

  static const baseUrl = 'https://gorest.co.in/public/v2';
  static const users = '/users';
  static const posts = '/posts';
  static const todos = '/todos';

  static const accessToken = String.fromEnvironment('GOREST_TOKEN');

  static Map<String, String> get defaultHeaders {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }
}
