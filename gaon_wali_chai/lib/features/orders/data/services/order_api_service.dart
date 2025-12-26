import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

/// Order API Service
class OrderApiService {
  final ApiService _api = ApiService();

  // Create order
  Future<ApiResponse> createOrder({
    int? addressId,
    String? specialInstructions,
  }) async {
    final body = {
      if (addressId != null) 'address_id': addressId,
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
    };

    return await _api.post(ApiConfig.orders, body);
  }

  // Get all orders
  Future<ApiResponse> getOrders({String? status}) async {
    String endpoint = ApiConfig.orders;
    if (status != null) {
      endpoint += '?status=$status';
    }
    return await _api.get(endpoint);
  }

  // Get order details
  Future<ApiResponse> getOrderDetails(int orderId) async {
    return await _api.get('${ApiConfig.orders}/$orderId');
  }
}
