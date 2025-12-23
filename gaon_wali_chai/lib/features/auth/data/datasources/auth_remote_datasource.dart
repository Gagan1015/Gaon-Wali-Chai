import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  // Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: ApiConstants.headers,
        body: jsonEncode({'name': name, 'phone': phone, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'phone': phone,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.verifyOtp),
        headers: ApiConstants.headers,
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': data['data']['token'],
          'user': User.fromJson(data['data']['user']),
          'message': data['message'] ?? 'Verification successful',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Invalid OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: ApiConstants.headers,
        body: jsonEncode({'phone': phone, 'password': password}),
      );

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check if data structure is correct
        if (data['data'] == null) {
          return {'success': false, 'message': 'Invalid response structure'};
        }

        return {
          'success': true,
          'token': data['data']['token'],
          'user': User.fromJson(data['data']['user']),
          'message': data['message'] ?? 'Login successful',
        };
      } else if (response.statusCode == 403) {
        // Phone not verified
        return {
          'success': false,
          'needsVerification': true,
          'phone': phone,
          'message': data['message'] ?? 'Please verify your phone number',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login Error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.resendOtp),
        headers: ApiConstants.headers,
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: ApiConstants.headers,
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Reset OTP sent',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Phone number not found',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: ApiConstants.headers,
        body: jsonEncode({'phone': phone, 'otp': otp, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password reset successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Invalid OTP or reset failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get User Profile
  Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getUser),
        headers: ApiConstants.authHeaders(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': User.fromJson(data['user'])};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch user',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Social Login (Google/Facebook)
  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String providerId,
    required String name,
    String? email,
    String? profileImage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.socialLogin),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'provider': provider,
          'provider_id': providerId,
          'name': name,
          'email': email,
          'profile_image': profileImage,
        }),
      );

      print('Social Login Response Status: ${response.statusCode}');
      print('Social Login Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['data'] == null) {
          return {'success': false, 'message': 'Invalid response structure'};
        }

        return {
          'success': true,
          'token': data['data']['token'],
          'user': User.fromJson(data['data']['user']),
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Social Login Error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.logout),
        headers: ApiConstants.authHeaders(token),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Logout successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Logout failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
