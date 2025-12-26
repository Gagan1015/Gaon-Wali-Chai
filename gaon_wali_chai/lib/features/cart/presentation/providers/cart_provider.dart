import 'package:flutter/material.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';
import '../../../../core/services/storage_service.dart';

/// Cart Provider - Manages cart state across the app
class CartProvider extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();
  final StorageService _storageService = StorageService();

  List<CartItemModel> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _cartCount = 0;

  List<CartItemModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get cartCount => _cartCount;

  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  /// Calculate total price
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.calculateTotal());
  }

  /// Calculate subtotal
  double get subtotal => totalPrice;

  /// Calculate tax (5%)
  double get tax => totalPrice * 0.05;

  /// Delivery fee
  double get deliveryFee => 20.0;

  /// Grand total
  double get grandTotal => subtotal + tax + deliveryFee;

  /// Initialize cart - load from API if authenticated
  Future<void> initialize() async {
    final hasToken = await _storageService.hasToken();
    if (hasToken) {
      await loadCart();
    }
  }

  /// Load cart from API
  Future<void> loadCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _cartRepository.getCart();

      if (response.success) {
        _cartItems = response.data ?? [];
        _updateCartCount();
        _errorMessage = null;
      } else {
        _errorMessage = response.message ?? 'Failed to load cart';
      }
    } catch (e) {
      _errorMessage = 'Error loading cart: ${e.toString()}';
      _cartItems = [];
      _cartCount = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add item to cart
  Future<bool> addToCart({
    required int productId,
    int? sizeId,
    List<int>? variantIds,
    required int quantity,
  }) async {
    try {
      final response = await _cartRepository.addToCart(
        productId: productId,
        sizeId: sizeId,
        variantIds: variantIds,
        quantity: quantity,
      );

      if (response.success) {
        // Reload cart to get updated items
        await loadCart();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to add to cart';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error adding to cart: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Update cart item quantity
  Future<bool> updateCartItem(int cartItemId, int quantity) async {
    try {
      final response = await _cartRepository.updateCartItem(
        cartItemId,
        quantity,
      );

      if (response.success) {
        // Update local state
        final index = _cartItems.indexWhere((item) => item.id == cartItemId);
        if (index != -1) {
          _cartItems[index] = response.data!;
          _updateCartCount();
          notifyListeners();
        }
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to update cart';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error updating cart: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Remove item from cart
  Future<bool> removeCartItem(int cartItemId) async {
    try {
      final response = await _cartRepository.removeCartItem(cartItemId);

      if (response.success) {
        _cartItems.removeWhere((item) => item.id == cartItemId);
        _updateCartCount();
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to remove item';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error removing item: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Clear entire cart
  Future<bool> clearCart() async {
    try {
      final response = await _cartRepository.clearCart();

      if (response.success) {
        _cartItems.clear();
        _cartCount = 0;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to clear cart';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error clearing cart: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Update cart count
  void _updateCartCount() {
    _cartCount = _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset cart (on logout)
  void reset() {
    _cartItems.clear();
    _cartCount = 0;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
