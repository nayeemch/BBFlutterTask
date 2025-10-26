import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exceptions/network_exceptions.dart';

class RestClient {
  // instantiate json decoder for json serialization
  final JsonDecoder _decoder = const JsonDecoder();
  final Map<String, String> defaultHeaders;

  RestClient({this.defaultHeaders = const {}});

  // GET
  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse(path), headers: _mergeHeaders(headers))
          .timeout(const Duration(seconds: 30));
      return _createResponse(response);
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out');
    }
  }

  // POST (JSON)
  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(path),
            headers: _mergeHeaders(headers),
            body: body,
            encoding: encoding,
          )
          .timeout(const Duration(seconds: 30));
      return _createResponse(response);
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out');
    }
  }

  // POST (Form)
  Future<dynamic> postFormData(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(path),
            headers: _mergeHeaders(headers),
            body: body,
          )
          .timeout(const Duration(seconds: 30));
      return _createResponse(response);
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out');
    }
  }

  // PUT
  Future<dynamic> put(
    String path, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(path),
            headers: _mergeHeaders(headers),
            body: body,
            encoding: encoding,
          )
          .timeout(const Duration(seconds: 30));
      return _createResponse(response);
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out');
    }
  }

  // DELETE
  Future<dynamic> delete(
    String path, {
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse(path),
            headers: _mergeHeaders(headers),
            body: body,
            encoding: encoding,
          )
          .timeout(const Duration(seconds: 30));
      return _createResponse(response);
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out');
    }
  }

  // Helpers
  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {...defaultHeaders, if (headers != null) ...headers};
  }

  dynamic _createResponse(http.Response response) {
    final body = response.body;
    final status = response.statusCode;

    // Parse JSON first (for both success and error responses)
    dynamic jsonResponse;
    if (body.isNotEmpty) {
      try {
        jsonResponse = _decoder.convert(body);
      } catch (_) {
        // If JSON parsing fails on error response, throw with generic message
        if (status < 200 || status >= 400) {
          throw NetworkException(
            message: 'Request failed [$status] - ${response.reasonPhrase}',
            statusCode: status,
          );
        }
        throw NetworkException(message: 'Invalid JSON response');
      }
    }

    // Handle error status codes (400, 401, 403, 500, etc.)
    if (status < 200 || status >= 400) {
      // Try to extract error message from API response
      String errorMessage =
          'Request failed [$status] - ${response.reasonPhrase}';

      if (jsonResponse is Map<String, dynamic>) {
        // Check if response has API error format with 'message' field
        if (jsonResponse.containsKey('message')) {
          errorMessage = jsonResponse['message'];
        }

        // Check if this is an authentication/authorization error
        if (jsonResponse.containsKey('code')) {
          final errorCode = jsonResponse['code'];
          // JWT/Auth related errors
          if (errorCode.toString().contains('jwt') ||
              errorCode.toString().contains('auth') ||
              status == 401 ||
              status == 403) {
            throw AuthException(
              message: errorMessage,
              statusCode: status,
            );
          }
        }
      }

      // For other errors, throw NetworkException
      throw NetworkException(
        message: errorMessage,
        statusCode: status,
      );
    }

    // Return the parsed response for successful requests
    return jsonResponse;
  }
}
