import 'dart:io';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:firefly_chat_mobile/services/auth_service.dart';
import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';

class HttpService {
  final String _baseUrl = 'http://10.0.2.2:3737/api';

  final Map<String, String> _headers = <String, String>{};

  Future<dynamic> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';

    if (headers != null) {
      headers.forEach((key, value) {
        _headers.addAll({key: value});
      });
    }

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
      );

      print("GET Response: ${response.statusCode} - ${response.body}");

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';
    _headers['Content-Type'] = "application/json";

    if (headers != null) {
      headers.forEach((key, value) {
        _headers.addAll({key: value});
      });
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
        body: jsonEncode(data),
      );

      print("POST Response: ${response.statusCode} - ${response.body}");

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';
    _headers['Content-Type'] = "application/json";

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, [Map<String, dynamic>? data]) async {
    final token = await AuthService().getToken();

    try {
      final request = http.Request('PATCH', Uri.parse("$_baseUrl/$endpoint"));

      request.headers.addAll({"Authorization": 'Bearer $token'});

      if (data != null) {
        request.headers.addAll({"Content-Type": 'application/json'});
        request.body = jsonEncode(data);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    _headers.clear();

    final token = await AuthService().getToken();

    _headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode == 401) {
      if (data['code'] == 'AUTH_EXPIRED_TOKEN') {
        // refreshToken().then((value) {}).catchError((error) {
        //   throw ApiExceptions(code: data['code'], message: data['message']);
        // });

        throw ApiExceptions(code: data['code'], message: data['message']);
      }
      throw ApiExceptions(code: data['code'], message: data['message']);
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiExceptions(code: data['code'], message: data['message']);
    }
  }
}

class GETResponse {
  final Map<String, String> headers;
  final dynamic body;
  final bool notModified;
  final int? maxAge;

  const GETResponse({
    required this.headers,
    required this.body,
    this.notModified = false,
    this.maxAge,
  });
}
