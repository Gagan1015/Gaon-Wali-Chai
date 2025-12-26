# Flutter App Integration Guide - Gaon Wali Chai Backend

## 📱 Complete Step-by-Step Integration Guide

This document provides detailed instructions for integrating your Flutter app with the Laravel backend API.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [API Configuration](#api-configuration)
4. [Authentication Integration](#authentication-integration)
5. [Product & Category Integration](#product--category-integration)
6. [Cart Integration](#cart-integration)
7. [Order Integration](#order-integration)
8. [Address Integration](#address-integration)
9. [Error Handling](#error-handling)
10. [Testing](#testing)
11. [Production Deployment](#production-deployment)

---

## Prerequisites

### Backend Requirements
- ✅ Laravel backend running at `http://localhost:8000`
- ✅ Database migrated and seeded
- ✅ All API endpoints tested

### Flutter Requirements
- Flutter SDK installed
- `http` package for API calls
- `provider` or `riverpod` for state management
- `flutter_secure_storage` for token storage

---

## Initial Setup

### Step 1: Add Dependencies

Add these packages to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
  provider: ^6.1.1  # or riverpod
  
dev_dependencies:
  mockito: ^5.4.4  # for testing
```

Run:
```bash
flutter pub get
```

### Step 2: Create Project Structure

Ensure your project has this structure:
```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # NEW - API configuration
│   ├── services/
│   │   ├── api_service.dart         # NEW - Base API service
│   │   └── storage_service.dart     # NEW - Token storage
│   └── utils/
│       └── api_response.dart        # NEW - Response wrapper
├── features/
│   ├── auth/
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── auth_repository.dart  # UPDATE
│   │       └── services/
│   │           └── auth_api_service.dart  # NEW
│   ├── menu/
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── product_repository.dart  # UPDATE
│   │       └── services/
│   │           └── product_api_service.dart  # NEW
│   ├── cart/
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── cart_repository.dart  # NEW
│   │       └── services/
│   │           └── cart_api_service.dart  # NEW
│   ├── orders/
│   │   └── data/
│   │       ├── repositories/
│   │       │   └── order_repository.dart  # NEW
│   │       └── services/
│   │           └── order_api_service.dart  # NEW
│   └── profile/
│       └── data/
│           ├── repositories/
│           │   └── address_repository.dart  # NEW
│           └── services/
│               └── address_api_service.dart  # NEW
```

---

## API Configuration

### Step 3: Create API Config File

Create `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  // Base URL - Change for production
  static const String baseUrl = 'http://localhost:8000/api';
  
  // For Android Emulator use: 'http://10.0.2.2:8000/api'
  // For iOS Simulator use: 'http://localhost:8000/api'
  // For Physical Device use: 'http://YOUR_LOCAL_IP:8000/api'
  // For Production use: 'https://api.gaonwalichai.com/api'
  
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
  
  static Map<String, String> headersWithAuth(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
```

### Step 4: Create Storage Service

Create `lib/core/services/storage_service.dart`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Token operations
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
  
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  // User data operations
  Future<void> saveUser(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }
  
  Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }
  
  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }
  
  // Clear all
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

### Step 5: Create Base API Service

Create `lib/core/services/api_service.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';
import '../utils/api_response.dart';

class ApiService {
  final StorageService _storage = StorageService();
  
  // GET request
  Future<ApiResponse> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken() ?? '')
          : ApiConfig.headers;
      
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }
  
  // POST request
  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken() ?? '')
          : ApiConfig.headers;
      
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }
  
  // PUT request
  Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken() ?? '')
          : ApiConfig.headers;
      
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }
  
  // DELETE request
  Future<ApiResponse> delete(String endpoint, {bool requiresAuth = false}) async {
    try {
      final headers = requiresAuth
          ? ApiConfig.headersWithAuth(await _storage.getToken() ?? '')
          : ApiConfig.headers;
      
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: headers,
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('Server error');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('Unexpected error: ${e.toString()}');
    }
  }
  
  // Handle response
  ApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;
    
    try {
      final data = jsonDecode(body);
      
      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse.success(data);
      } else if (statusCode == 401) {
        return ApiResponse.error('Unauthorized', statusCode: 401);
      } else if (statusCode == 404) {
        return ApiResponse.error('Not found', statusCode: 404);
      } else if (statusCode == 422) {
        // Validation error
        final errors = data['errors'] as Map<String, dynamic>?;
        final message = errors?.values.first.first ?? 'Validation failed';
        return ApiResponse.error(message, statusCode: 422);
      } else {
        final message = data['message'] ?? 'Request failed';
        return ApiResponse.error(message, statusCode: statusCode);
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response');
    }
  }
}
```

### Step 6: Create API Response Wrapper

Create `lib/core/utils/api_response.dart`:

```dart
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  
  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });
  
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }
  
  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
```

---

## Authentication Integration

### Step 7: Update Auth Repository

Update `lib/features/auth/data/repositories/auth_repository.dart`:

```dart
import 'package:gaon_wali_chai/core/services/storage_service.dart';
import '../services/auth_api_service.dart';
import '../../domain/models/user_model.dart';

class AuthRepository {
  final AuthApiService _apiService = AuthApiService();
  final StorageService _storage = StorageService();
  
  // Login
  Future<ApiResponse<UserModel>> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final token = data['token'];
      final user = UserModel.fromJson(data['user']);
      
      // Save token
      await _storage.saveToken(token);
      
      return ApiResponse.success(user);
    }
    
    return ApiResponse.error(response.message ?? 'Login failed');
  }
  
  // Register
  Future<ApiResponse<UserModel>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _apiService.register(name, email, password);
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final token = data['token'];
      final user = UserModel.fromJson(data['user']);
      
      await _storage.saveToken(token);
      
      return ApiResponse.success(user);
    }
    
    return ApiResponse.error(response.message ?? 'Registration failed');
  }
  
  // Get current user
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _apiService.getCurrentUser();
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final user = UserModel.fromJson(data['data']);
      return ApiResponse.success(user);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get user');
  }
  
  // Logout
  Future<void> logout() async {
    await _apiService.logout();
    await _storage.clearAll();
  }
  
  // Check if logged in
  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }
}
```

Create `lib/features/auth/data/services/auth_api_service.dart`:

```dart
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

class AuthApiService {
  final ApiService _api = ApiService();
  
  Future<ApiResponse> login(String email, String password) async {
    return await _api.post(
      '${ApiConfig.auth}/login',
      {'email': email, 'password': password},
    );
  }
  
  Future<ApiResponse> register(String name, String email, String password) async {
    return await _api.post(
      '${ApiConfig.auth}/register',
      {'name': name, 'email': email, 'password': password},
    );
  }
  
  Future<ApiResponse> getCurrentUser() async {
    return await _api.get('${ApiConfig.auth}/user', requiresAuth: true);
  }
  
  Future<ApiResponse> logout() async {
    return await _api.post('${ApiConfig.auth}/logout', {}, requiresAuth: true);
  }
}
```

---

## Product & Category Integration

### Step 8: Create Product API Service

Create `lib/features/menu/data/services/product_api_service.dart`:

```dart
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

class ProductApiService {
  final ApiService _api = ApiService();
  
  // Get all categories
  Future<ApiResponse> getCategories() async {
    return await _api.get(ApiConfig.categories);
  }
  
  // Get all products
  Future<ApiResponse> getProducts({
    int? categoryId,
    bool? featured,
    String? search,
    int? page,
    int? perPage,
  }) async {
    String endpoint = ApiConfig.products;
    List<String> queryParams = [];
    
    if (categoryId != null) queryParams.add('category_id=$categoryId');
    if (featured != null) queryParams.add('featured=$featured');
    if (search != null) queryParams.add('search=$search');
    if (page != null) queryParams.add('page=$page');
    if (perPage != null) queryParams.add('per_page=$perPage');
    
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }
    
    return await _api.get(endpoint);
  }
  
  // Get product details
  Future<ApiResponse> getProductDetails(int productId) async {
    return await _api.get('${ApiConfig.products}/$productId');
  }
}
```

### Step 9: Update Product Repository

Create `lib/features/menu/data/repositories/product_repository.dart`:

```dart
import '../services/product_api_service.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../../../core/utils/api_response.dart';

class ProductRepository {
  final ProductApiService _apiService = ProductApiService();
  
  // Get categories
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    final response = await _apiService.getCategories();
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final categoriesJson = data['data'] as List;
      final categories = categoriesJson
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      
      return ApiResponse.success(categories);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get categories');
  }
  
  // Get products
  Future<ApiResponse<List<ProductModel>>> getProducts({
    int? categoryId,
    bool? featured,
    String? search,
  }) async {
    final response = await _apiService.getProducts(
      categoryId: categoryId,
      featured: featured,
      search: search,
    );
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final productsJson = data['data'] as List;
      final products = productsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();
      
      return ApiResponse.success(products);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get products');
  }
  
  // Get product details
  Future<ApiResponse<ProductModel>> getProductDetails(int productId) async {
    final response = await _apiService.getProductDetails(productId);
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final product = ProductModel.fromJson(data['data']);
      
      return ApiResponse.success(product);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get product');
  }
}
```

---

## Cart Integration

### Step 10: Create Cart Models

Create `lib/features/cart/data/models/cart_model.dart`:

```dart
import 'cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  
  CartModel({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
  });
  
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      subtotal: double.parse(json['subtotal'].toString()),
      tax: double.parse(json['tax'].toString()),
      deliveryFee: double.parse(json['delivery_fee'].toString()),
      total: double.parse(json['total'].toString()),
    );
  }
}
```

Create `lib/features/cart/data/models/cart_item_model.dart`:

```dart
class CartItemModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final int sizeId;
  final String sizeName;
  final int quantity;
  final double basePrice;
  final List<CartItemVariant> variants;
  final double itemTotal;
  
  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.sizeId,
    required this.sizeName,
    required this.quantity,
    required this.basePrice,
    required this.variants,
    required this.itemTotal,
  });
  
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'] ?? '',
      sizeId: json['size_id'],
      sizeName: json['size_name'],
      quantity: json['quantity'],
      basePrice: double.parse(json['base_price'].toString()),
      variants: (json['variants'] as List?)
              ?.map((v) => CartItemVariant.fromJson(v))
              .toList() ??
          [],
      itemTotal: double.parse(json['item_total'].toString()),
    );
  }
}

class CartItemVariant {
  final int variantId;
  final String variantName;
  final double price;
  
  CartItemVariant({
    required this.variantId,
    required this.variantName,
    required this.price,
  });
  
  factory CartItemVariant.fromJson(Map<String, dynamic> json) {
    return CartItemVariant(
      variantId: json['variant_id'],
      variantName: json['variant_name'],
      price: double.parse(json['price'].toString()),
    );
  }
}
```

### Step 11: Create Cart API Service

Create `lib/features/cart/data/services/cart_api_service.dart`:

```dart
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

class CartApiService {
  final ApiService _api = ApiService();
  
  // Get cart
  Future<ApiResponse> getCart() async {
    return await _api.get(ApiConfig.cart, requiresAuth: true);
  }
  
  // Add to cart
  Future<ApiResponse> addToCart({
    required int productId,
    required int sizeId,
    required int quantity,
    List<int>? variantIds,
  }) async {
    return await _api.post(
      '${ApiConfig.cart}/add',
      {
        'product_id': productId,
        'size_id': sizeId,
        'quantity': quantity,
        if (variantIds != null) 'variant_ids': variantIds,
      },
      requiresAuth: true,
    );
  }
  
  // Update cart item
  Future<ApiResponse> updateCartItem(int itemId, int quantity) async {
    return await _api.put(
      '${ApiConfig.cart}/$itemId',
      {'quantity': quantity},
      requiresAuth: true,
    );
  }
  
  // Remove from cart
  Future<ApiResponse> removeFromCart(int itemId) async {
    return await _api.delete(
      '${ApiConfig.cart}/$itemId',
      requiresAuth: true,
    );
  }
  
  // Clear cart
  Future<ApiResponse> clearCart() async {
    return await _api.delete(
      '${ApiConfig.cart}/clear/all',
      requiresAuth: true,
    );
  }
}
```

### Step 12: Create Cart Repository

Create `lib/features/cart/data/repositories/cart_repository.dart`:

```dart
import '../services/cart_api_service.dart';
import '../models/cart_model.dart';
import '../../../../core/utils/api_response.dart';

class CartRepository {
  final CartApiService _apiService = CartApiService();
  
  // Get cart
  Future<ApiResponse<CartModel>> getCart() async {
    final response = await _apiService.getCart();
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final cart = CartModel.fromJson(data['data']);
      return ApiResponse.success(cart);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get cart');
  }
  
  // Add to cart
  Future<ApiResponse<Map<String, dynamic>>> addToCart({
    required int productId,
    required int sizeId,
    required int quantity,
    List<int>? variantIds,
  }) async {
    final response = await _apiService.addToCart(
      productId: productId,
      sizeId: sizeId,
      quantity: quantity,
      variantIds: variantIds,
    );
    
    if (response.success) {
      return ApiResponse.success(response.data);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to add to cart');
  }
  
  // Update quantity
  Future<ApiResponse> updateQuantity(int itemId, int quantity) async {
    final response = await _apiService.updateCartItem(itemId, quantity);
    
    if (response.success) {
      return ApiResponse.success(null);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to update cart');
  }
  
  // Remove item
  Future<ApiResponse> removeItem(int itemId) async {
    final response = await _apiService.removeFromCart(itemId);
    
    if (response.success) {
      return ApiResponse.success(null);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to remove item');
  }
  
  // Clear cart
  Future<ApiResponse> clearCart() async {
    final response = await _apiService.clearCart();
    
    if (response.success) {
      return ApiResponse.success(null);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to clear cart');
  }
}
```

---

## Order Integration

### Step 13: Create Order Models

Create `lib/features/orders/data/models/order_model.dart`:

```dart
import 'order_item_model.dart';
import '../../../profile/data/models/address_model.dart';

class OrderModel {
  final int id;
  final String orderNumber;
  final String status;
  final List<OrderItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final AddressModel? deliveryAddress;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  
  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    this.deliveryAddress,
    this.specialInstructions,
    required this.createdAt,
    this.estimatedDeliveryTime,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'],
      status: json['status'],
      items: (json['items'] as List?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
      subtotal: double.parse(json['subtotal'].toString()),
      tax: double.parse(json['tax'].toString()),
      deliveryFee: double.parse(json['delivery_fee'].toString()),
      total: double.parse(json['total'].toString()),
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      deliveryAddress: json['delivery_address'] != null
          ? AddressModel.fromJson(json['delivery_address'])
          : null,
      specialInstructions: json['special_instructions'],
      createdAt: DateTime.parse(json['created_at']),
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'])
          : null,
    );
  }
}
```

Create `lib/features/orders/data/models/order_item_model.dart`:

```dart
class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final String sizeName;
  final double sizePrice;
  final int quantity;
  final List<OrderItemVariant> variants;
  final double itemTotal;
  
  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.sizeName,
    required this.sizePrice,
    required this.quantity,
    required this.variants,
    required this.itemTotal,
  });
  
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'] ?? '',
      sizeName: json['size_name'],
      sizePrice: double.parse(json['size_price'].toString()),
      quantity: json['quantity'],
      variants: (json['variants'] as List?)
              ?.map((v) => OrderItemVariant.fromJson(v))
              .toList() ??
          [],
      itemTotal: double.parse(json['item_total'].toString()),
    );
  }
}

class OrderItemVariant {
  final String variantName;
  final double variantPrice;
  
  OrderItemVariant({
    required this.variantName,
    required this.variantPrice,
  });
  
  factory OrderItemVariant.fromJson(Map<String, dynamic> json) {
    return OrderItemVariant(
      variantName: json['variant_name'],
      variantPrice: double.parse(json['variant_price'].toString()),
    );
  }
}
```

### Step 14: Create Order API Service & Repository

Create `lib/features/orders/data/services/order_api_service.dart`:

```dart
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

class OrderApiService {
  final ApiService _api = ApiService();
  
  // Create order
  Future<ApiResponse> createOrder({
    required String paymentMethod,
    required int deliveryAddressId,
    String? specialInstructions,
  }) async {
    return await _api.post(
      ApiConfig.orders,
      {
        'payment_method': paymentMethod,
        'delivery_address_id': deliveryAddressId,
        if (specialInstructions != null)
          'special_instructions': specialInstructions,
      },
      requiresAuth: true,
    );
  }
  
  // Get orders
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
```

Create `lib/features/orders/data/repositories/order_repository.dart`:

```dart
import '../services/order_api_service.dart';
import '../models/order_model.dart';
import '../../../../core/utils/api_response.dart';

class OrderRepository {
  final OrderApiService _apiService = OrderApiService();
  
  // Create order
  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String paymentMethod,
    required int deliveryAddressId,
    String? specialInstructions,
  }) async {
    final response = await _apiService.createOrder(
      paymentMethod: paymentMethod,
      deliveryAddressId: deliveryAddressId,
      specialInstructions: specialInstructions,
    );
    
    if (response.success) {
      return ApiResponse.success(response.data['data']);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to create order');
  }
  
  // Get orders
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
  Future<ApiResponse<OrderModel>> getOrderDetails(String orderNumber) async {
    final response = await _apiService.getOrderDetails(orderNumber);
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final order = OrderModel.fromJson(data['data']);
      
      return ApiResponse.success(order);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get order');
  }
}
```

---

## Address Integration

### Step 15: Create Address Model

Create `lib/features/profile/data/models/address_model.dart`:

```dart
class AddressModel {
  final int id;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  
  AddressModel({
    required this.id,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefault,
  });
  
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      label: json['label'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      isDefault: json['is_default'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'is_default': isDefault,
    };
  }
  
  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2,
      city,
      state,
      pincode,
    ];
    return parts.join(', ');
  }
}
```

### Step 16: Create Address API Service & Repository

Create `lib/features/profile/data/services/address_api_service.dart`:

```dart
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

class AddressApiService {
  final ApiService _api = ApiService();
  
  Future<ApiResponse> getAddresses() async {
    return await _api.get(ApiConfig.addresses, requiresAuth: true);
  }
  
  Future<ApiResponse> createAddress(Map<String, dynamic> address) async {
    return await _api.post(
      ApiConfig.addresses,
      address,
      requiresAuth: true,
    );
  }
  
  Future<ApiResponse> updateAddress(int id, Map<String, dynamic> address) async {
    return await _api.put(
      '${ApiConfig.addresses}/$id',
      address,
      requiresAuth: true,
    );
  }
  
  Future<ApiResponse> deleteAddress(int id) async {
    return await _api.delete(
      '${ApiConfig.addresses}/$id',
      requiresAuth: true,
    );
  }
}
```

Create `lib/features/profile/data/repositories/address_repository.dart`:

```dart
import '../services/address_api_service.dart';
import '../models/address_model.dart';
import '../../../../core/utils/api_response.dart';

class AddressRepository {
  final AddressApiService _apiService = AddressApiService();
  
  Future<ApiResponse<List<AddressModel>>> getAddresses() async {
    final response = await _apiService.getAddresses();
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final addressesJson = data['data'] as List;
      final addresses = addressesJson
          .map((json) => AddressModel.fromJson(json))
          .toList();
      
      return ApiResponse.success(addresses);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to get addresses');
  }
  
  Future<ApiResponse<AddressModel>> createAddress(AddressModel address) async {
    final response = await _apiService.createAddress(address.toJson());
    
    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final newAddress = AddressModel.fromJson(data['data']);
      return ApiResponse.success(newAddress);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to create address');
  }
  
  Future<ApiResponse> updateAddress(int id, AddressModel address) async {
    final response = await _apiService.updateAddress(id, address.toJson());
    
    if (response.success) {
      return ApiResponse.success(null);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to update address');
  }
  
  Future<ApiResponse> deleteAddress(int id) async {
    final response = await _apiService.deleteAddress(id);
    
    if (response.success) {
      return ApiResponse.success(null);
    }
    
    return ApiResponse.error(response.message ?? 'Failed to delete address');
  }
}
```

---

## Error Handling

### Step 17: Create Error Handler

Create `lib/core/utils/error_handler.dart`:

```dart
import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    return 'An unexpected error occurred';
  }
}
```

---

## Testing

### Step 18: Test API Integration

Create test file `test/api_integration_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gaon_wali_chai/core/services/api_service.dart';
import 'package:gaon_wali_chai/features/menu/data/repositories/product_repository.dart';

void main() {
  group('API Integration Tests', () {
    test('Get categories should return list', () async {
      final repo = ProductRepository();
      final response = await repo.getCategories();
      
      expect(response.success, true);
      expect(response.data, isNotNull);
      expect(response.data!.isNotEmpty, true);
    });
    
    test('Get products should return list', () async {
      final repo = ProductRepository();
      final response = await repo.getProducts();
      
      expect(response.success, true);
      expect(response.data, isNotNull);
    });
    
    test('Get featured products should return filtered list', () async {
      final repo = ProductRepository();
      final response = await repo.getProducts(featured: true);
      
      expect(response.success, true);
      if (response.data != null && response.data!.isNotEmpty) {
        expect(response.data!.every((p) => p.isFeatured), true);
      }
    });
  });
}
```

---

## Production Deployment

### Step 19: Update for Production

1. **Update API Base URL:**

In `lib/core/config/api_config.dart`:
```dart
static const String baseUrl = 'https://api.gaonwalichai.com/api';
```

2. **Enable HTTPS:**

Ensure your backend has SSL certificate and HTTPS enabled.

3. **Handle Different Environments:**

```dart
class ApiConfig {
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  
  static String get baseUrl {
    switch (env) {
      case 'prod':
        return 'https://api.gaonwalichai.com/api';
      case 'staging':
        return 'https://staging-api.gaonwalichai.com/api';
      default:
        return 'http://localhost:8000/api';
    }
  }
}
```

Run with environment:
```bash
flutter run --dart-define=ENV=prod
```

4. **Add Logging (Optional):**

```dart
import 'package:logger/logger.dart';

class ApiService {
  final Logger _logger = Logger();
  
  ApiResponse _handleResponse(http.Response response) {
    _logger.d('Response: ${response.statusCode} - ${response.body}');
    // ... rest of the code
  }
}
```

---

## Complete Usage Examples

### Example 1: Fetch and Display Products

```dart
class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ProductRepository _repo = ProductRepository();
  List<ProductModel> _products = [];
  bool _loading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    
    final response = await _repo.getProducts();
    
    if (response.success && response.data != null) {
      setState(() {
        _products = response.data!;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ErrorHandler.showError(context, response.message ?? 'Failed to load');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_loading) return CircularProgressIndicator();
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductCard(product: product);
      },
    );
  }
}
```

### Example 2: Add to Cart

```dart
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  
  ProductDetailScreen({required this.product});
  
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartRepository _cartRepo = CartRepository();
  int? _selectedSizeId;
  List<int> _selectedVariantIds = [];
  int _quantity = 1;
  bool _adding = false;
  
  Future<void> _addToCart() async {
    if (_selectedSizeId == null) {
      ErrorHandler.showError(context, 'Please select a size');
      return;
    }
    
    setState(() => _adding = true);
    
    final response = await _cartRepo.addToCart(
      productId: widget.product.id,
      sizeId: _selectedSizeId!,
      quantity: _quantity,
      variantIds: _selectedVariantIds.isEmpty ? null : _selectedVariantIds,
    );
    
    setState(() => _adding = false);
    
    if (response.success) {
      ErrorHandler.showSuccess(context, 'Added to cart');
      Navigator.pop(context);
    } else {
      ErrorHandler.showError(context, response.message ?? 'Failed to add');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Product details
          // Size selector
          // Variant selector
          // Quantity selector
          
          ElevatedButton(
            onPressed: _adding ? null : _addToCart,
            child: _adding
                ? CircularProgressIndicator()
                : Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
```

### Example 3: Create Order

```dart
class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderRepository _orderRepo = OrderRepository();
  final AddressRepository _addressRepo = AddressRepository();
  
  List<AddressModel> _addresses = [];
  int? _selectedAddressId;
  String _paymentMethod = 'upi';
  bool _creating = false;
  
  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }
  
  Future<void> _loadAddresses() async {
    final response = await _addressRepo.getAddresses();
    if (response.success && response.data != null) {
      setState(() {
        _addresses = response.data!;
        _selectedAddressId = _addresses
            .firstWhere((a) => a.isDefault, orElse: () => _addresses.first)
            .id;
      });
    }
  }
  
  Future<void> _placeOrder() async {
    if (_selectedAddressId == null) {
      ErrorHandler.showError(context, 'Please select delivery address');
      return;
    }
    
    setState(() => _creating = true);
    
    final response = await _orderRepo.createOrder(
      paymentMethod: _paymentMethod,
      deliveryAddressId: _selectedAddressId!,
    );
    
    setState(() => _creating = false);
    
    if (response.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(
            orderNumber: response.data!['order_id'],
          ),
        ),
      );
    } else {
      ErrorHandler.showError(context, response.message ?? 'Failed to place order');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Address selection
          // Payment method selection
          
          ElevatedButton(
            onPressed: _creating ? null : _placeOrder,
            child: _creating
                ? CircularProgressIndicator()
                : Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
```

---

## Troubleshooting

### Common Issues

1. **Connection Refused (Android Emulator)**
   - Use `http://10.0.2.2:8000/api` instead of `localhost`

2. **SSL Certificate Issues**
   - For development, you may need to allow HTTP in Android manifest
   - Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <application
       android:usesCleartextTraffic="true">
   ```

3. **CORS Errors**
   - Ensure backend has proper CORS configuration
   - Check `config/cors.php` in Laravel

4. **Token Expired**
   - Implement token refresh logic
   - Handle 401 responses by logging out user

5. **Timeout Issues**
   - Increase timeout duration in ApiConfig
   - Check network connectivity

---

## Summary Checklist

- ✅ API configuration set up
- ✅ Storage service for tokens
- ✅ Base API service with error handling
- ✅ Product & Category integration
- ✅ Cart management
- ✅ Order creation and tracking
- ✅ Address management
- ✅ Error handling
- ✅ Testing
- ✅ Production configuration

---

## Next Steps

1. **Implement UI Updates**
   - Update screens to use new repositories
   - Add loading states
   - Add error handling

2. **Add State Management**
   - Use Provider/Riverpod for global state
   - Manage cart count badge
   - Cache product data

3. **Enhance UX**
   - Add pull-to-refresh
   - Implement skeleton loaders
   - Add offline mode

4. **Add Features**
   - Image upload for profile
   - Payment gateway integration
   - Push notifications
   - Order tracking

---

## 🎉 You're Ready to Integrate!

Your Flutter app is now ready to communicate with the Laravel backend. All API services, repositories, and models are set up according to best practices.

Start by updating one screen at a time, test thoroughly, and gradually migrate all features to use the backend API.

**Happy coding! 🚀**
