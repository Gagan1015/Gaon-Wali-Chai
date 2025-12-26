import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';
import '../utils/api_response.dart';

/// Base API service for making HTTP requests
class ApiService {
  final StorageService _storage = StorageService();

  // GET request
  Future<ApiResponse> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken())
          : ApiConfig.headers;

      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  // POST request
  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken())
          : ApiConfig.headers;

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  // PUT request
  Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken())
          : ApiConfig.headers;

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  // DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken())
          : ApiConfig.headers;

      final response = await http
          .delete(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }

  // Handle response
  ApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    try {
      final data = jsonDecode(body);

      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse.success(data);
      } else if (statusCode == 401) {
        return ApiResponse.error('Unauthorized', statusCode: 401);
      } else if (statusCode == 404) {
        return ApiResponse.error('Not found', statusCode: 404);
      } else if (statusCode == 422) {
        // Validation error
        final errors = data['errors'] as Map<String, dynamic>?;
        final message = errors?.values.first.first ?? 'Validation failed';
        return ApiResponse.error(message, statusCode: 422);
      } else {
        final message = data['message'] ?? 'Request failed';
        return ApiResponse.error(message, statusCode: statusCode);
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response');
    }
  }
}
