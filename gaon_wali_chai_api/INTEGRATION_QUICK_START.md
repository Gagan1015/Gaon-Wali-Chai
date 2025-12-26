# Flutter Integration Quick Reference

## 🚀 Quick Start Checklist

### 1. Backend Setup (Already Done ✅)
- ✅ Server running at `http://localhost:8000`
- ✅ Database migrated with 10 tables
- ✅ Sample data seeded
- ✅ 21 API endpoints ready

### 2. Flutter Setup (To Do)

#### Add Dependencies
```yaml
# pubspec.yaml
dependencies:
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
  provider: ^6.1.1
```

#### Update API Base URL
```dart
// lib/core/config/api_config.dart
static const String baseUrl = 'http://10.0.2.2:8000/api';  // Android Emulator
// OR
static const String baseUrl = 'http://localhost:8000/api';  // iOS Simulator
```

---

## 📁 Files to Create

### Core Services (3 files)
```
lib/core/
├── config/
│   └── api_config.dart              ← Create
├── services/
│   ├── api_service.dart             ← Create
│   └── storage_service.dart         ← Create
└── utils/
    └── api_response.dart            ← Create
```

### Feature Services (5 files)
```
lib/features/
├── auth/data/services/
│   └── auth_api_service.dart        ← Create
├── menu/data/services/
│   └── product_api_service.dart     ← Create
├── cart/data/services/
│   └── cart_api_service.dart        ← Create
├── orders/data/services/
│   └── order_api_service.dart       ← Create
└── profile/data/services/
    └── address_api_service.dart     ← Create
```

### Feature Repositories (5 files)
```
lib/features/
├── auth/data/repositories/
│   └── auth_repository.dart         ← Update
├── menu/data/repositories/
│   └── product_repository.dart      ← Update
├── cart/data/repositories/
│   └── cart_repository.dart         ← Create
├── orders/data/repositories/
│   └── order_repository.dart        ← Create
└── profile/data/repositories/
    └── address_repository.dart      ← Create
```

### New Models (3 files)
```
lib/features/
├── cart/data/models/
│   ├── cart_model.dart              ← Create
│   └── cart_item_model.dart         ← Create
├── orders/data/models/
│   ├── order_model.dart             ← Create
│   └── order_item_model.dart        ← Create
└── profile/data/models/
    └── address_model.dart           ← Create
```

**Total: 16 new files + 2 updated files**

---

## 📋 Integration Steps

### Step 1: Core Setup (30 min)
1. Create `api_config.dart`
2. Create `storage_service.dart`
3. Create `api_service.dart`
4. Create `api_response.dart`

### Step 2: Products (20 min)
1. Create `product_api_service.dart`
2. Update `product_repository.dart`
3. Test product listing

### Step 3: Cart (30 min)
1. Create cart models
2. Create `cart_api_service.dart`
3. Create `cart_repository.dart`
4. Test add to cart

### Step 4: Orders (30 min)
1. Create order models
2. Create `order_api_service.dart`
3. Create `order_repository.dart`
4. Test order creation

### Step 5: Addresses (20 min)
1. Create address model
2. Create `address_api_service.dart`
3. Create `address_repository.dart`
4. Test address CRUD

### Step 6: Update UI (60 min)
1. Update screens to use repositories
2. Add loading states
3. Add error handling
4. Test complete flows

**Total Time: ~3 hours**

---

## 🔗 API Endpoints Quick Reference

### Products
```dart
// Get all products
GET /products

// Get featured products
GET /products?featured=true

// Get by category
GET /products?category_id=1

// Search
GET /products?search=chai

// Get details
GET /products/1
```

### Cart (Requires Auth)
```dart
// Get cart
GET /cart

// Add to cart
POST /cart/add
{
  "product_id": 1,
  "size_id": 2,
  "quantity": 1,
  "variant_ids": [1, 2]  // optional
}

// Update
PUT /cart/1
{ "quantity": 3 }

// Remove
DELETE /cart/1

// Clear
DELETE /cart/clear/all
```

### Orders (Requires Auth)
```dart
// Create order
POST /orders
{
  "payment_method": "upi",
  "delivery_address_id": 1,
  "special_instructions": "Less sugar"  // optional
}

// Get orders
GET /orders

// Get order details
GET /orders/ORD-123456
```

### Addresses (Requires Auth)
```dart
// Get all
GET /addresses

// Create
POST /addresses
{
  "label": "Home",
  "address_line1": "123 Street",
  "city": "Mumbai",
  "state": "Maharashtra",
  "pincode": "400001",
  "is_default": true
}

// Update
PUT /addresses/1

// Delete
DELETE /addresses/1
```

---

## 💡 Code Snippets

### Basic API Call Pattern
```dart
// In Repository
Future<ApiResponse<List<Product>>> getProducts() async {
  final response = await _apiService.getProducts();
  
  if (response.success) {
    final data = response.data['data'] as List;
    final products = data.map((json) => Product.fromJson(json)).toList();
    return ApiResponse.success(products);
  }
  
  return ApiResponse.error(response.message ?? 'Failed');
}

// In UI
Future<void> _loadProducts() async {
  setState(() => _loading = true);
  
  final response = await _repo.getProducts();
  
  if (response.success) {
    setState(() {
      _products = response.data!;
      _loading = false;
    });
  } else {
    setState(() => _loading = false);
    ErrorHandler.showError(context, response.message!);
  }
}
```

### Add to Cart
```dart
final response = await _cartRepo.addToCart(
  productId: 1,
  sizeId: 2,
  quantity: 1,
  variantIds: [1, 2],
);

if (response.success) {
  ErrorHandler.showSuccess(context, 'Added to cart');
}
```

### Create Order
```dart
final response = await _orderRepo.createOrder(
  paymentMethod: 'upi',
  deliveryAddressId: selectedAddressId,
  specialInstructions: 'Less sugar',
);

if (response.success) {
  final orderNumber = response.data!['order_id'];
  Navigator.push(context, OrderSuccessScreen(orderNumber));
}
```

---

## 🧪 Testing

### Test Backend First
```bash
# Start server
cd c:\Projects\gaon_wali_chai_api
php artisan serve

# Test in browser
http://localhost:8000/api/products
```

### Test in Postman
1. Import: `Gaon_Wali_Chai_API_Complete.postman_collection.json`
2. Set base URL: `http://localhost:8000/api`
3. Test each endpoint
4. Get auth token from login
5. Use token in protected endpoints

### Test in Flutter
```dart
// Add to main.dart for testing
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test API connection
  final api = ApiService();
  final response = await api.get('/products');
  print('API Test: ${response.success}');
  
  runApp(MyApp());
}
```

---

## 🐛 Common Issues & Solutions

### Issue 1: Connection Refused
**Problem:** Can't connect to localhost
**Solution:** 
- Android Emulator: Use `http://10.0.2.2:8000/api`
- Physical Device: Use your computer's IP `http://192.168.x.x:8000/api`

### Issue 2: Token Not Saved
**Problem:** Auth token not persisting
**Solution:** Ensure `flutter_secure_storage` is properly configured
```dart
await StorageService().saveToken(token);
```

### Issue 3: CORS Error
**Problem:** CORS policy blocking requests
**Solution:** Check backend `config/cors.php` allows your origin

### Issue 4: Validation Errors
**Problem:** 422 validation error
**Solution:** Check request body matches expected format
```dart
{
  "product_id": 1,  // Must be integer
  "size_id": 2,     // Must exist in database
  "quantity": 1     // Must be >= 1
}
```

---

## 📱 Platform-Specific Setup

### Android
Enable cleartext traffic for development:
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application
    android:usesCleartextTraffic="true">
```

### iOS
Add to `Info.plist` for development:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 🎯 Testing Checklist

- [ ] Backend server running
- [ ] Test products endpoint in browser
- [ ] Test with Postman collection
- [ ] Core services created in Flutter
- [ ] API config updated with correct URL
- [ ] Test product listing in app
- [ ] Test add to cart
- [ ] Test order creation
- [ ] Test address CRUD
- [ ] Handle all error cases
- [ ] Add loading states
- [ ] Test complete user flow

---

## 📞 Need Help?

**Full Guide:** `FLUTTER_INTEGRATION_GUIDE.md`  
**API Docs:** `API_DOCUMENTATION_COMPLETE.md`  
**Postman:** `Gaon_Wali_Chai_API_Complete.postman_collection.json`

---

## ✨ Success Criteria

Your integration is complete when:
- ✅ Products display from API
- ✅ Categories filter products
- ✅ Add to cart works
- ✅ Cart shows items with totals
- ✅ Order creation works
- ✅ Order history displays
- ✅ Addresses can be managed
- ✅ Error handling works
- ✅ Loading states show properly
- ✅ Complete user flow works end-to-end

---

**Time to integrate: ~3 hours for core features**

**Let's build something amazing! 🚀☕**
