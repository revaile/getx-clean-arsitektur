class ApiConstants {
  const ApiConstants._();

  static const baseUrl = 'https://gorest.co.in/public/v2';
  static const users = '/users';
  static const posts = '/posts';
  static const todos = '/todos';

  static const accessToken =
      '11b662b2162ef20139b9ae4e3a8350e7c35baea7fa60975a89faf90e702ca7ab';

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
