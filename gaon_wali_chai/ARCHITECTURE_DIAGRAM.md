# 🏗️ Flutter + Laravel Architecture Diagram

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUTTER APPLICATION                             │
│                         (gaon_wali_chai)                               │
└─────────────────────────────────────────────────────────────────────────┘
                                   │
                                   │
                    ┌──────────────┴──────────────┐
                    │                             │
                    ▼                             ▼
        ┌────────────────────┐        ┌────────────────────┐
        │   PRESENTATION     │        │   PRESENTATION     │
        │   (UI Screens)     │        │   (UI Screens)     │
        ├────────────────────┤        ├────────────────────┤
        │ menu_screen_new    │        │ cart_screen        │
        │ product_detail     │        │                    │
        └────────────────────┘        └────────────────────┘
                    │                             │
                    └──────────────┬──────────────┘
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │     REPOSITORY LAYER         │
                    │   (Business Logic)           │
                    ├──────────────────────────────┤
                    │ ProductRepository            │
                    │ CartRepository               │
                    │ OrderRepository              │
                    │ AddressRepository            │
                    └──────────────────────────────┘
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │    API SERVICE LAYER         │
                    │   (Endpoint Specific)        │
                    ├──────────────────────────────┤
                    │ ProductApiService            │
                    │ CartApiService               │
                    │ OrderApiService              │
                    │ AddressApiService            │
                    └──────────────────────────────┘
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │    CORE HTTP SERVICE         │
                    ├──────────────────────────────┤
                    │ ApiService                   │
                    │  - GET, POST, PUT, DELETE    │
                    │  - Error handling            │
                    │  - Token injection           │
                    │                              │
                    │ StorageService               │
                    │  - Token storage             │
                    │  - User data cache           │
                    │                              │
                    │ ApiConfig                    │
                    │  - Base URL                  │
                    │  - Endpoints                 │
                    │  - Headers                   │
                    └──────────────────────────────┘
                                   │
                                   │ HTTP Request
                                   │ (JSON)
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       LARAVEL BACKEND API                               │
│                     (gaon_wali_chai_api)                               │
└─────────────────────────────────────────────────────────────────────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    │                             │
                    ▼                             ▼
        ┌────────────────────┐        ┌────────────────────┐
        │   ROUTES LAYER     │        │   MIDDLEWARE       │
        │   (api.php)        │        │   (auth:sanctum)   │
        ├────────────────────┤        ├────────────────────┤
        │ /categories        │        │ Token validation   │
        │ /products          │        │ User auth          │
        │ /cart              │        │ Rate limiting      │
        │ /orders            │        └────────────────────┘
        │ /addresses         │
        └────────────────────┘
                    │
                    ▼
        ┌────────────────────────────────────┐
        │      CONTROLLERS LAYER             │
        │   (Request Handling)               │
        ├────────────────────────────────────┤
        │ CategoryController                 │
        │  - index(), show()                 │
        │                                    │
        │ ProductController                  │
        │  - index(), show()                 │
        │                                    │
        │ CartController                     │
        │  - index(), add()                  │
        │  - update(), remove(), clear()     │
        │                                    │
        │ OrderController                    │
        │  - store(), index(), show()        │
        │                                    │
        │ AddressController                  │
        │  - index(), store(), show()        │
        │  - update(), destroy()             │
        └────────────────────────────────────┘
                    │
                    ▼
        ┌────────────────────────────────────┐
        │       MODELS LAYER                 │
        │   (Eloquent ORM)                   │
        ├────────────────────────────────────┤
        │ Category                           │
        │  - hasMany(products)               │
        │                                    │
        │ Product                            │
        │  - belongsTo(category)             │
        │  - hasMany(sizes, variants)        │
        │                                    │
        │ CartItem                           │
        │  - belongsTo(user, product, size)  │
        │  - belongsToMany(variants)         │
        │                                    │
        │ Order                              │
        │  - belongsTo(user)                 │
        │  - hasMany(items)                  │
        │                                    │
        │ Address                            │
        │  - belongsTo(user)                 │
        └────────────────────────────────────┘
                    │
                    ▼
        ┌────────────────────────────────────┐
        │       DATABASE LAYER               │
        │   (MySQL)                          │
        ├────────────────────────────────────┤
        │ categories                         │
        │ products                           │
        │ product_sizes                      │
        │ product_variants                   │
        │ cart_items                         │
        │ cart_item_variants                 │
        │ orders                             │
        │ order_items                        │
        │ order_item_variants                │
        │ addresses                          │
        │ users                              │
        └────────────────────────────────────┘
```

---

## Data Flow: Complete User Journey

### Example: Add Product to Cart

```
USER ACTION                    FLUTTER                          BACKEND
─────────────────────────────────────────────────────────────────────────

1. Tap "Add to Cart"
   on product detail
                               │
                               ▼
                       ProductDetailScreen
                       (validates selections)
                               │
                               ▼
                       CartRepository.addToCart()
                       (business logic)
                               │
                               ▼
                       CartApiService.addToCart()
                       (prepare request)
                               │
                               ▼
                       ApiService.post()
                       (HTTP client)
                       - Adds auth token
                       - Sets headers
                       - Handles errors
                               │
                               │ POST /api/cart
                               │ {
                               │   product_id: 5,
                               │   size_id: 2,
                               │   variant_ids: [1, 3],
                               │   quantity: 2
                               │ }
                               │
                               ▼
                                                                routes/api.php
                                                                (auth:sanctum)
                               │                                      │
                               │                                      ▼
                               │                            CartController@add
                               │                            - Validates request
                               │                            - Checks product exists
                               │                            - Verifies variants
                               │                                      │
                               │                                      ▼
                               │                            CartItem::create()
                               │                            - Saves to DB
                               │                            - Attaches variants
                               │                                      │
                               │                                      ▼
                               │                            Database
                               │                            - INSERT cart_items
                               │                            - INSERT cart_item_variants
                               │                                      │
                               │                                      ▼
                               │                            CartItem with relations
                               │                            - product
                               │                            - size
                               │                            - variants
                               │                                      │
                               │ ◄───────────────────────────────────┘
                               │ 201 Created
                               │ {
                               │   success: true,
                               │   data: { cart_item }
                               │ }
                               ▼
                       ApiService receives response
                               │
                               ▼
                       CartApiService returns ApiResponse
                               │
                               ▼
                       CartRepository.addToCart()
                       - Parses to CartItemModel
                       - Returns typed response
                               │
                               ▼
                       ProductDetailScreen
                       - Hides loading
                       - Shows success message
                       - Navigates back
                               │
                               ▼
2. User sees success                   
   "Product added to cart"
```

---

## Request/Response Structure

### Example: Get Products

#### Request
```
┌─────────────────────────────────┐
│ GET /api/products?category_id=2 │
└─────────────────────────────────┘
         │
         │ Headers:
         │ - Accept: application/json
         │ - Authorization: Bearer {token}
         ▼
    Backend API
         │
         ▼
```

#### Response
```json
{
  "success": true,
  "message": "Products retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Masala Chai",
      "description": "Spiced tea with authentic Indian masala",
      "base_price": 60,
      "image": "https://...",
      "category_id": 2,
      "is_available": true,
      "category": {
        "id": 2,
        "name": "Tea"
      },
      "sizes": [
        {
          "id": 1,
          "name": "Small",
          "price": 50
        },
        {
          "id": 2,
          "name": "Medium",
          "price": 60
        },
        {
          "id": 3,
          "name": "Large",
          "price": 70
        }
      ],
      "variants": [
        {
          "id": 1,
          "name": "Extra Sugar",
          "additional_price": 0
        },
        {
          "id": 2,
          "name": "Less Sugar",
          "additional_price": 0
        },
        {
          "id": 3,
          "name": "Extra Milk",
          "additional_price": 10
        }
      ]
    }
  ]
}
```

---

## File Structure Mapping

### Flutter (Frontend)
```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart                 → API endpoints, base URL
│   ├── services/
│   │   ├── api_service.dart                → HTTP client (GET, POST, PUT, DELETE)
│   │   └── storage_service.dart            → Token & data storage
│   └── utils/
│       └── api_response.dart               → Response wrapper
│
├── features/
│   ├── menu/
│   │   ├── data/
│   │   │   ├── models/                     → ProductModel, CategoryModel
│   │   │   ├── services/                   → ProductApiService
│   │   │   └── repositories/               → ProductRepository
│   │   └── presentation/
│   │       └── screens/                    → menu_screen_new.dart
│   │
│   ├── cart/
│   │   ├── data/
│   │   │   ├── models/                     → CartItemModel
│   │   │   ├── services/                   → CartApiService
│   │   │   └── repositories/               → CartRepository
│   │   └── presentation/
│   │       └── screens/                    → cart_screen.dart
│   │
│   ├── orders/
│   │   └── data/
│   │       ├── models/                     → OrderModel
│   │       ├── services/                   → OrderApiService
│   │       └── repositories/               → OrderRepository
│   │
│   └── profile/
│       └── data/
│           ├── models/                     → AddressModel
│           ├── services/                   → AddressApiService
│           └── repositories/               → AddressRepository
```

### Laravel (Backend)
```
gaon_wali_chai_api/
├── routes/
│   └── api.php                             → API routes definition
│
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       ├── CategoryController.php      → /categories endpoints
│   │       ├── ProductController.php       → /products endpoints
│   │       ├── CartController.php          → /cart endpoints
│   │       ├── OrderController.php         → /orders endpoints
│   │       └── AddressController.php       → /addresses endpoints
│   │
│   └── Models/
│       ├── Category.php
│       ├── Product.php
│       ├── ProductSize.php
│       ├── ProductVariant.php
│       ├── CartItem.php
│       ├── CartItemVariant.php
│       ├── Order.php
│       ├── OrderItem.php
│       ├── OrderItemVariant.php
│       └── Address.php
│
└── database/
    └── migrations/
        ├── create_categories_table.php
        ├── create_products_table.php
        ├── create_product_sizes_table.php
        ├── create_product_variants_table.php
        ├── create_cart_items_table.php
        ├── create_cart_item_variants_table.php
        ├── create_orders_table.php
        ├── create_order_items_table.php
        ├── create_order_item_variants_table.php
        └── create_addresses_table.php
```

---

## Security Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    AUTHENTICATION FLOW                      │
└─────────────────────────────────────────────────────────────┘

1. User Login
   ├─ Flutter: AuthRepository.login(email, password)
   ├─ Backend: AuthController@login
   ├─ Validates credentials
   ├─ Creates Sanctum token
   └─ Returns: { token, user }

2. Store Token
   └─ Flutter: StorageService.saveToken(token)
      └─ Saved in FlutterSecureStorage (encrypted)

3. Subsequent Requests
   ├─ Flutter: ApiService.get/post/put/delete()
   ├─ Automatically adds header: "Authorization: Bearer {token}"
   ├─ Backend: auth:sanctum middleware
   ├─ Validates token
   ├─ Injects $request->user()
   └─ Returns: authenticated response

4. Token Invalid/Expired
   ├─ Backend returns: 401 Unauthorized
   ├─ Flutter ApiService catches error
   ├─ Clears token: StorageService.clearAll()
   └─ Redirects to login screen
```

---

## Error Handling Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    ERROR HANDLING                           │
└─────────────────────────────────────────────────────────────┘

TRY
│
├─ API Call (e.g., CartRepository.addToCart())
│  │
│  ├─ Network Error (timeout, no internet)
│  │  └─ Catch: SocketException
│  │     └─ Return: ApiResponse.error("Network error")
│  │
│  ├─ Server Error (500)
│  │  └─ Catch: Response code 500
│  │     └─ Return: ApiResponse.error("Server error")
│  │
│  ├─ Validation Error (422)
│  │  └─ Parse errors object
│  │     └─ Return: ApiResponse.error("Validation failed: ...")
│  │
│  ├─ Unauthorized (401)
│  │  └─ Clear token
│  │     └─ Navigate to login
│  │
│  └─ Success (200, 201)
│     └─ Parse response data
│        └─ Return: ApiResponse.success(data)
│
CATCH
│
└─ UI Layer
   ├─ if (response.success)
   │  └─ Show success message / Update UI
   │
   └─ else
      └─ Show error message / Display error state
```

---

## Performance Optimization

### Caching Strategy
```
ProductRepository.getProducts()
├─ Check cache (optional future enhancement)
│  ├─ If cache valid → Return cached data
│  └─ If cache expired → Fetch from API
│
└─ API Response
   ├─ Store in cache
   └─ Return to UI
```

### Loading States
```
Screen State Machine:
├─ Initial: Loading = true
├─ API Call in progress: Loading = true
├─ Success: Loading = false, Data displayed
└─ Error: Loading = false, Error message shown
```

---

## Testing Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     TESTING LAYERS                          │
└─────────────────────────────────────────────────────────────┘

Backend Testing
├─ Unit Tests
│  ├─ Model relationships
│  ├─ Business logic
│  └─ Helper functions
│
├─ Feature Tests
│  ├─ API endpoint responses
│  ├─ Authentication
│  └─ Database interactions
│
└─ Integration Tests
   ├─ Complete user flows
   └─ External service interactions

Frontend Testing
├─ Unit Tests
│  ├─ Model parsing (fromJson)
│  ├─ Utility functions
│  └─ Repository logic
│
├─ Widget Tests
│  ├─ Screen rendering
│  ├─ User interactions
│  └─ State management
│
└─ Integration Tests
   ├─ Complete flows (add to cart, checkout)
   └─ API mocking
```

---

**This architecture provides:**
- ✅ Clean separation of concerns
- ✅ Easy to test and maintain
- ✅ Scalable for future features
- ✅ Type-safe data flow
- ✅ Consistent error handling
- ✅ Secure authentication
- ✅ Performance optimized
