# Gaon Wali Chai - Backend Setup & Quick Start

## 🚀 Quick Start

### Prerequisites
- PHP 8.2+
- Composer
- MySQL
- Laravel 11

### Installation & Setup

1. **Install Dependencies**
```bash
cd c:\Projects\gaon_wali_chai_api
composer install
```

2. **Environment Setup**
```bash
cp .env.example .env
php artisan key:generate
```

3. **Database Configuration**
Edit `.env` file with your database credentials:
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=gaon_wali_chai
DB_USERNAME=root
DB_PASSWORD=
```

4. **Run Migrations**
```bash
php artisan migrate
```

5. **Seed Sample Data**
```bash
php artisan db:seed
```

6. **Start Development Server**
```bash
php artisan serve
```

Server will be available at: `http://localhost:8000`

---

## 📁 Project Structure

```
gaon_wali_chai_api/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       ├── AuthController.php
│   │       ├── CategoryController.php
│   │       ├── ProductController.php
│   │       ├── CartController.php
│   │       ├── OrderController.php
│   │       └── AddressController.php
│   └── Models/
│       ├── User.php
│       ├── Category.php
│       ├── Product.php
│       ├── ProductSize.php
│       ├── ProductVariant.php
│       ├── Address.php
│       ├── CartItem.php
│       ├── CartItemVariant.php
│       ├── Order.php
│       ├── OrderItem.php
│       └── OrderItemVariant.php
├── database/
│   ├── migrations/
│   │   ├── 2025_12_26_073136_create_categories_table.php
│   │   ├── 2025_12_26_073154_create_products_table.php
│   │   ├── 2025_12_26_073156_create_product_sizes_table.php
│   │   ├── 2025_12_26_073158_create_product_variants_table.php
│   │   ├── 2025_12_26_073159_create_addresses_table.php
│   │   ├── 2025_12_26_073200_create_cart_items_table.php
│   │   ├── 2025_12_26_073201_create_cart_item_variants_table.php
│   │   ├── 2025_12_26_073203_create_orders_table.php
│   │   ├── 2025_12_26_073204_create_order_items_table.php
│   │   └── 2025_12_26_073205_create_order_item_variants_table.php
│   └── seeders/
│       └── DatabaseSeeder.php
├── routes/
│   └── api.php
├── API_DOCUMENTATION_COMPLETE.md
├── BACKEND_IMPLEMENTATION_COMPLETE.md
└── Gaon_Wali_Chai_API_Complete.postman_collection.json
```

---

## 🔗 API Endpoints

### Base URL
```
http://localhost:8000/api
```

### Public Endpoints (No Authentication)
- `GET /categories` - Get all categories
- `GET /categories/{id}` - Get single category
- `GET /products` - Get all products (with filters)
- `GET /products/{id}` - Get product details

### Protected Endpoints (Require Authentication)

**Cart:**
- `GET /cart` - Get user's cart
- `POST /cart/add` - Add item to cart
- `PUT /cart/{itemId}` - Update cart item
- `DELETE /cart/{itemId}` - Remove from cart
- `DELETE /cart/clear/all` - Clear cart

**Orders:**
- `GET /orders` - Get user's orders
- `POST /orders` - Create new order
- `GET /orders/{orderNumber}` - Get order details

**Addresses:**
- `GET /addresses` - Get user's addresses
- `POST /addresses` - Create new address
- `GET /addresses/{id}` - Get single address
- `PUT /addresses/{id}` - Update address
- `DELETE /addresses/{id}` - Delete address

---

## 🧪 Quick Test

### Test Public Endpoint
```bash
curl http://localhost:8000/api/products
```

### Expected Response
```json
{
  "data": [
    {
      "id": 1,
      "name": "Kulhad Chai",
      "base_price": "50.00",
      "is_featured": true,
      "category": { ... },
      "sizes": [ ... ],
      "variants": [ ... ]
    }
  ],
  "meta": { ... }
}
```

---

## 📚 Documentation

- **Complete API Documentation:** `API_DOCUMENTATION_COMPLETE.md`
- **Implementation Summary:** `BACKEND_IMPLEMENTATION_COMPLETE.md`
- **Postman Collection:** `Gaon_Wali_Chai_API_Complete.postman_collection.json`

---

## 🗄️ Database Tables

1. **categories** - Product categories
2. **products** - Product catalog
3. **product_sizes** - Size options
4. **product_variants** - Add-ons/variants
5. **addresses** - Delivery addresses
6. **cart_items** - Shopping cart
7. **cart_item_variants** - Cart item variants
8. **orders** - Order records
9. **order_items** - Order line items
10. **order_item_variants** - Order item variants

---

## 🌱 Sample Data

After seeding, you'll have:
- 4 Categories (Kulhad Tea, Snacks, Desserts, Shakes)
- 6 Products with sizes and variants
- Ready to test complete workflows

---

## 🔐 Authentication

The API uses Laravel Sanctum for authentication. 

### Get Authentication Token
1. Register or login using existing auth endpoints
2. Token will be returned in response
3. Include token in Authorization header:
   ```
   Authorization: Bearer {token}
   ```

---

## 🛠️ Development Commands

### Run migrations
```bash
php artisan migrate
```

### Rollback migrations
```bash
php artisan migrate:rollback
```

### Fresh migration with seed
```bash
php artisan migrate:fresh --seed
```

### Clear cache
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

### View routes
```bash
php artisan route:list
```

---

## 📦 Import Postman Collection

1. Open Postman
2. Click Import
3. Select `Gaon_Wali_Chai_API_Complete.postman_collection.json`
4. Set `token` variable with your authentication token
5. Start testing!

---

## ✅ What's Included

- ✅ Complete database schema
- ✅ All Eloquent models with relationships
- ✅ Full CRUD operations
- ✅ Cart management system
- ✅ Order creation and tracking
- ✅ Address management
- ✅ Product catalog with sizes and variants
- ✅ Price calculation logic
- ✅ Sample data seeded
- ✅ Complete API documentation
- ✅ Postman collection
- ✅ Validation on all inputs
- ✅ Error handling

---

## 🎯 Ready for Flutter Integration

The backend is fully implemented and ready to integrate with your Flutter app. All endpoints match the expected data structures in the Flutter models.

### Next Steps:
1. Update API base URL in Flutter app
2. Test endpoints using Postman
3. Integrate API calls in Flutter repositories
4. Implement error handling
5. Add loading states
6. Test complete user flows

---

## 📞 Support

For questions or issues:
1. Check `API_DOCUMENTATION_COMPLETE.md` for detailed API reference
2. Review `BACKEND_IMPLEMENTATION_COMPLETE.md` for implementation details
3. Test endpoints using Postman collection

---

## 🎉 Happy Coding!

The backend is complete and ready for your Flutter app!
