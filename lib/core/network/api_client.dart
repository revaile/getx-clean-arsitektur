import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  const ApiClient({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final response = await _client.get(
      _uri(path),
      headers: _mergeHeaders(headers),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.post(
      _uri(path),
      headers: _mergeHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.put(
      _uri(path),
      headers: _mergeHeaders(headers),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<void> delete(String path, {Map<String, String>? headers}) async {
    final response = await _client.delete(
      _uri(path),
      headers: _mergeHeaders(headers),
    );

    _handleResponse(response);
  }

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {
      ...ApiConstants.defaultHeaders,
      if (headers != null) ...headers,
    };
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isEmpty ? null : jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    final message = switch (body) {
      {'message': final Object message} => message.toString(),
      List<dynamic> errors => errors
          .map((error) {
            if (error is Map<String, dynamic>) {
              final field = error['field']?.toString();
              final message = error['message']?.toString();
              return [field, message].whereType<String>().join(' ');
            }

            return error.toString();
          })
          .where((message) => message.trim().isNotEmpty)
          .join(', '),
      _ => response.reasonPhrase,
    };

    throw ServerException(
      message?.isNotEmpty == true ? message! : 'Request failed',
      statusCode: statusCode,
    );
  }
}
