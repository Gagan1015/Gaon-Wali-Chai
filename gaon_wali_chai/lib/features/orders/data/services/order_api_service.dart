import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

/// Order API Service
class OrderApiService {
  final ApiService _api = ApiService();

  // Create order
  Future<ApiResponse> createOrder({
    required String paymentMethod,
    required int deliveryAddressId,
    String? specialInstructions,
  }) async {
    final body = {
      'payment_method': paymentMethod,
      'delivery_address_id': deliveryAddressId,
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
    };

    return await _api.post(ApiConfig.orders, body, requiresAuth: true);
  }

  // Get all orders
  Future<ApiResponse> getOrders({String? status}) async {
    String endpoint = ApiConfig.orders;
    if (status != null) {
      endpoint += '?status=$status';
    }
    return await _api.get(endpoint, requiresAuth: true);
  }

  // Get order details
  Future<ApiResponse> getOrderDetails(String orderNumber) async {
    return await _api.get(
      '${ApiConfig.orders}/$orderNumber',
      requiresAuth: true,
    );
  }
}
