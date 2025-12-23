import 'package:flutter/material.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRemoteDatasource _remoteDatasource = AuthRemoteDatasource();
  final AuthLocalDatasource _localDatasource = AuthLocalDatasource();

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  // Initialize - Check if user is already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final isLoggedIn = await _localDatasource.isLoggedIn();
    if (isLoggedIn) {
      _token = await _localDatasource.getToken();
      if (_token != null) {
        await fetchUser();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.register(
      name: name,
      phone: phone,
      password: password,
    );

    _isLoading = false;
    if (!result['success']) {
      _error = result['message'];
    }
    notifyListeners();

    return result;
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.verifyOtp(phone: phone, otp: otp);

    if (result['success']) {
      _token = result['token'];
      _user = result['user'];
      await _localDatasource.saveToken(_token!);
      await _localDatasource.saveUserInfo(_user!.id, _user!.phone);
    } else {
      _error = result['message'];
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.login(
      phone: phone,
      password: password,
    );

    if (result['success']) {
      _token = result['token'];
      _user = result['user'];
      await _localDatasource.saveToken(_token!);
      await _localDatasource.saveUserInfo(_user!.id, _user!.phone);
    } else {
      _error = result['message'];
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Resend OTP
  Future<Map<String, dynamic>> resendOtp(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.resendOtp(phone);

    _isLoading = false;
    if (!result['success']) {
      _error = result['message'];
    }
    notifyListeners();

    return result;
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.forgotPassword(phone);

    _isLoading = false;
    if (!result['success']) {
      _error = result['message'];
    }
    notifyListeners();

    return result;
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.resetPassword(
      phone: phone,
      otp: otp,
      password: password,
    );

    _isLoading = false;
    if (!result['success']) {
      _error = result['message'];
    }
    notifyListeners();

    return result;
  }

  // Social Login
  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String providerId,
    required String name,
    String? email,
    String? profileImage,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _remoteDatasource.socialLogin(
      provider: provider,
      providerId: providerId,
      name: name,
      email: email,
      profileImage: profileImage,
    );

    if (result['success']) {
      _token = result['token'];
      _user = result['user'];
      await _localDatasource.saveToken(_token!);
      await _localDatasource.saveUserInfo(_user!.id, _user!.phone ?? '');
    } else {
      _error = result['message'];
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  // Fetch User Profile
  Future<void> fetchUser() async {
    if (_token == null) return;

    final result = await _remoteDatasource.getUser(_token!);
    if (result['success']) {
      _user = result['user'];
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    if (_token != null) {
      await _remoteDatasource.logout(_token!);
    }

    await _localDatasource.clearAll();
    _user = null;
    _token = null;
    _error = null;

    _isLoading = false;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
