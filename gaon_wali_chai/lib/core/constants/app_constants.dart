/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'Gaon Wali Chai';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Traditional Indian Chai & More';

  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;

  // Cart
  static const int maxQuantityPerItem = 10;
  static const int minQuantityPerItem = 1;

  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusPreparing = 'preparing';
  static const String orderStatusReady = 'ready';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  // Payment Methods
  static const String paymentMethodUPI = 'upi';
  static const String paymentMethodCard = 'card';
  static const String paymentMethodCash = 'cash';

  // Product Sizes
  static const String sizeSmall = 'Small';
  static const String sizeMedium = 'Medium';
  static const String sizeLarge = 'Large';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);

  // Cache
  static const Duration cacheExpiry = Duration(hours: 1);

  // Images
  static const String placeholderImageUrl = 'https://via.placeholder.com/300';
  static const double productImageAspectRatio = 1.0;

  // Address
  static const int maxAddresses = 5;

  // Phone
  static const String phoneNumberPrefix = '+91';
  static const int phoneNumberLength = 10;

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorAuth = 'Authentication failed. Please login again.';

  // Success Messages
  static const String successAddToCart = 'Added to cart successfully';
  static const String successRemoveFromCart = 'Removed from cart';
  static const String successOrderPlaced = 'Order placed successfully';
  static const String successProfileUpdated = 'Profile updated successfully';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';
}
