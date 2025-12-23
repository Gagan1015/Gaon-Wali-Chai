# Flutter Integration Guide

This guide will help you integrate the Gaon Wali Chai API with your Flutter frontend.

## Base Configuration

### API Constants
Create a constants file for API endpoints:

```dart
// lib/core/constants/api_constants.dart

class ApiConstants {
  // Base URL - Update this based on your environment
  static const String baseUrl = 'http://localhost:8000/api';
  
  // For Android Emulator use:
  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // For iOS Simulator use:
  // static const String baseUrl = 'http://localhost:8000/api';
  
  // For Physical Device use your computer's IP:
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // Auth Endpoints
  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String login = '$baseUrl/auth/login';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String socialLogin = '$baseUrl/auth/social-login';
  static const String getUser = '$baseUrl/auth/user';
  static const String updateProfile = '$baseUrl/auth/update-profile';
  static const String logout = '$baseUrl/auth/logout';
}
```

## API Service Class

Create a service to handle API calls:

```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gaon_wali_chai/core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({required this.client});

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.register),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.verifyOtp),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Resend OTP
  Future<Map<String, dynamic>> resendOtp({
    required String phone,
    required String type,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.resendOtp),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'type': type,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Login
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.login),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Forgot Password
  Future<Map<String, dynamic>> forgotPassword({
    required String phone,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.forgotPassword),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await client.post(
      Uri.parse(ApiConstants.resetPassword),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Get User Profile
  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await client.get(
      Uri.parse(ApiConstants.getUser),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  /// Logout
  Future<void> logout(String token) async {
    final response = await client.post(
      Uri.parse(ApiConstants.logout),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
```

## User Model

```dart
// lib/features/auth/data/models/user_model.dart

class UserModel {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? profileImage;
  final bool isVerified;
  final String authProvider;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.profileImage,
    required this.isVerified,
    required this.authProvider,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profileImage: json['profile_image'],
      isVerified: json['is_verified'],
      authProvider: json['auth_provider'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'auth_provider': authProvider,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

## Token Storage

```dart
// lib/features/auth/data/datasources/auth_local_datasource.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage storage;

  AuthLocalDataSource({required this.storage});

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Save token
  Future<void> saveToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  /// Get token
  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  /// Delete token
  Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
  }

  /// Save user data
  Future<void> saveUser(String userData) async {
    await storage.write(key: _userKey, value: userData);
  }

  /// Get user data
  Future<String?> getUser() async {
    return await storage.read(key: _userKey);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await storage.deleteAll();
  }
}
```

## Provider/State Management Example (using Riverpod)

```dart
// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaon_wali_chai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:gaon_wali_chai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gaon_wali_chai/features/auth/data/models/user_model.dart';

class AuthState {
  final UserModel? user;
  final String? token;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthNotifier({
    required this.remoteDataSource,
    required this.localDataSource,
  }) : super(AuthState());

  /// Register
  Future<bool> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await remoteDataSource.register(
        name: name,
        phone: phone,
        password: password,
      );
      
      state = state.copyWith(isLoading: false);
      return response['success'];
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await remoteDataSource.verifyOtp(
        phone: phone,
        otp: otp,
      );
      
      if (response['success']) {
        final token = response['data']['token'];
        final user = UserModel.fromJson(response['data']['user']);
        
        await localDataSource.saveToken(token);
        await localDataSource.saveUser(user.toJson().toString());
        
        state = state.copyWith(
          user: user,
          token: token,
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Login
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await remoteDataSource.login(
        phone: phone,
        password: password,
      );
      
      if (response['success']) {
        final token = response['data']['token'];
        final user = UserModel.fromJson(response['data']['user']);
        
        await localDataSource.saveToken(token);
        await localDataSource.saveUser(user.toJson().toString());
        
        state = state.copyWith(
          user: user,
          token: token,
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    if (state.token != null) {
      await remoteDataSource.logout(state.token!);
    }
    await localDataSource.clearAll();
    state = AuthState();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Initialize your data sources here
  throw UnimplementedError();
});
```

## Usage Example in Widget

```dart
// Example: Sign Up Screen

class SignUpScreen extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: authState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final success = await ref
                          .read(authProvider.notifier)
                          .register(
                            name: nameController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          );

                      if (success) {
                        // Navigate to OTP verification screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyOtpScreen(
                              phone: phoneController.text,
                            ),
                          ),
                        );
                      } else {
                        // Show error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authState.error ?? 'Error')),
                        );
                      }
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
    );
  }
}
```

## Error Handling

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

// In your data source:
Future<Map<String, dynamic>> login(...) async {
  try {
    final response = await client.post(...);
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200 && data['success']) {
      return data;
    } else {
      throw ApiException(
        message: data['message'] ?? 'Unknown error',
        statusCode: response.statusCode,
      );
    }
  } catch (e) {
    if (e is ApiException) rethrow;
    throw ApiException(message: 'Network error: $e');
  }
}
```

## Important Notes

1. **Update Base URL**: Change the `baseUrl` in `ApiConstants` based on your environment
2. **Token Management**: Always store tokens securely using `flutter_secure_storage`
3. **Error Handling**: Properly handle all error responses from the API
4. **Loading States**: Show loading indicators during API calls
5. **OTP Handling**: The OTP is currently logged in Laravel logs for development

## Testing

For testing, you can check the Laravel logs for OTPs:

```bash
tail -f storage/logs/laravel.log
```

Or use a fixed OTP for testing by modifying the `OtpService.php`.

---

Ready to integrate! 🚀
