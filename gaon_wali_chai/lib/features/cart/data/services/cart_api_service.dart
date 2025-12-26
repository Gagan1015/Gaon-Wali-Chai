import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

/// Cart API Service
class CartApiService {
  final ApiService _api = ApiService();

  // Get cart items
  Future<ApiResponse> getCart() async {
    return await _api.get(ApiConfig.cart, requiresAuth: true);
  }

  // Add to cart
  Future<ApiResponse> addToCart({
    required int productId,
    int? sizeId,
    List<int>? variantIds,
    required int quantity,
  }) async {
    final body = {
      'product_id': productId,
      if (sizeId != null) 'size_id': sizeId,
      if (variantIds != null) 'variant_ids': variantIds,
      'quantity': quantity,
    };

    return await _api.post(ApiConfig.cart, body, requiresAuth: true);
  }

  // Update cart item
  Future<ApiResponse> updateCartItem(int cartItemId, int quantity) async {
    final body = {'quantity': quantity};
    return await _api.put(
      '${ApiConfig.cart}/$cartItemId',
      body,
      requiresAuth: true,
    );
  }

  // Remove cart item
  Future<ApiResponse> removeCartItem(int cartItemId) async {
    return await _api.delete(
      '${ApiConfig.cart}/$cartItemId',
      requiresAuth: true,
    );
  }

  // Clear cart
  Future<ApiResponse> clearCart() async {
    return await _api.delete('${ApiConfig.cart}/clear', requiresAuth: true);
  }
}
