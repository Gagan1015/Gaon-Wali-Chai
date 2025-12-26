import '../services/cart_api_service.dart';
import '../models/cart_item_model.dart';
import '../../../../core/utils/api_response.dart';

/// Cart Repository
class CartRepository {
  final CartApiService _apiService = CartApiService();

  // Get cart items
  Future<ApiResponse<List<CartItemModel>>> getCart() async {
    try {
      final response = await _apiService.getCart();

      if (response.success) {
        final data = response.data as Map<String, dynamic>;
        final cartData = data['data'] as Map<String, dynamic>;
        final itemsJson = cartData['items'] as List;
        final items = itemsJson
            .map((json) => CartItemModel.fromJson(json))
            .toList();

        return ApiResponse.success(items);
      }

      return ApiResponse.error(response.message ?? 'Failed to get cart');
    } catch (e) {
      return ApiResponse.error('Error parsing cart: ${e.toString()}');
    }
  }

  // Add to cart
  Future<ApiResponse<Map<String, dynamic>>> addToCart({
    required int productId,
    int? sizeId,
    List<int>? variantIds,
    required int quantity,
  }) async {
    final response = await _apiService.addToCart(
      productId: productId,
      sizeId: sizeId,
      variantIds: variantIds,
      quantity: quantity,
    );

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      // Backend returns: {cart_item_id: int, cart_count: int}
      return ApiResponse.success(data['data'] as Map<String, dynamic>);
    }

    return ApiResponse.error(response.message ?? 'Failed to add to cart');
  }

  // Update cart item quantity
  Future<ApiResponse<CartItemModel>> updateCartItem(
    int cartItemId,
    int quantity,
  ) async {
    final response = await _apiService.updateCartItem(cartItemId, quantity);

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final cartItem = CartItemModel.fromJson(data['data']);

      return ApiResponse.success(cartItem);
    }

    return ApiResponse.error(response.message ?? 'Failed to update cart');
  }

  // Remove cart item
  Future<ApiResponse<String>> removeCartItem(int cartItemId) async {
    final response = await _apiService.removeCartItem(cartItemId);

    if (response.success) {
      return ApiResponse.success('Item removed successfully');
    }

    return ApiResponse.error(response.message ?? 'Failed to remove item');
  }

  // Clear cart
  Future<ApiResponse<String>> clearCart() async {
    final response = await _apiService.clearCart();

    if (response.success) {
      return ApiResponse.success('Cart cleared successfully');
    }

    return ApiResponse.error(response.message ?? 'Failed to clear cart');
  }
}
