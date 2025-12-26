import '../services/order_api_service.dart';
import '../models/order_model.dart';
import '../../../../core/utils/api_response.dart';

/// Order Repository
class OrderRepository {
  final OrderApiService _apiService = OrderApiService();

  // Create order
  Future<ApiResponse<OrderModel>> createOrder({
    int? addressId,
    String? specialInstructions,
  }) async {
    final response = await _apiService.createOrder(
      addressId: addressId,
      specialInstructions: specialInstructions,
    );

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final order = OrderModel.fromJson(data['data']);

      return ApiResponse.success(order);
    }

    return ApiResponse.error(response.message ?? 'Failed to create order');
  }

  // Get all orders
  Future<ApiResponse<List<OrderModel>>> getOrders({String? status}) async {
    final response = await _apiService.getOrders(status: status);

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final ordersJson = data['data'] as List;
      final orders = ordersJson
          .map((json) => OrderModel.fromJson(json))
          .toList();

      return ApiResponse.success(orders);
    }

    return ApiResponse.error(response.message ?? 'Failed to get orders');
  }

  // Get order details
  Future<ApiResponse<OrderModel>> getOrderDetails(int orderId) async {
    final response = await _apiService.getOrderDetails(orderId);

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final order = OrderModel.fromJson(data['data']);

      return ApiResponse.success(order);
    }

    return ApiResponse.error(response.message ?? 'Failed to get order details');
  }
}
