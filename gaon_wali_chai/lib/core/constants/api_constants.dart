class ApiConstants {
  // Base URL - Update this based on your environment
  // For Android Emulator: use 10.0.2.2
  // For iOS Simulator: use localhost
  // For Physical Device: use your computer's IP address
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Authentication Endpoints
  static const String register = '$baseUrl/auth/register';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String socialLogin = '$baseUrl/auth/social-login';
  static const String getUser = '$baseUrl/auth/user';
  static const String updateProfile = '$baseUrl/auth/update-profile';

  // Headers
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
