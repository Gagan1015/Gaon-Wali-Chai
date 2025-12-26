/// API Configuration
class ApiConfig {
  // Base URL - Change for production
  // For Android Emulator use: 'http://10.0.2.2:8000/api'
  // For iOS Simulator use: 'http://localhost:8000/api'
  // For Physical Device use: 'http://YOUR_LOCAL_IP:8000/api'
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Endpoints
  static const String auth = '/auth';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String addresses = '/addresses';

  // Timeout
  static const Duration timeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithAuth(String? token) => {
    ...headers,
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
}
