# Gaon Wali Chai - Complete API Documentation

## Base URL
```
http://localhost:8000/api
```

## Authentication
Most endpoints require authentication using Laravel Sanctum tokens. Include the token in the Authorization header:
```
Authorization: Bearer {token}
```

---

## 📋 Categories

### Get All Categories
Get list of all active categories.

**Endpoint:** `GET /categories`  
**Authentication:** Not required

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Kulhad Tea",
      "icon": "url",
      "sort_order": 1,
      "is_active": true,
      "created_at": "2025-12-26T07:31:36.000000Z",
      "updated_at": "2025-12-26T07:31:36.000000Z"
    }
  ]
}
```

### Get Single Category
Get details of a specific category.

**Endpoint:** `GET /categories/{id}`  
**Authentication:** Not required

**Response:**
```json
{
  "data": {
    "id": 1,
    "name": "Kulhad Tea",
    "icon": "url",
    "sort_order": 1,
    "is_active": true
  }
}
```

---

## 🍵 Products

### Get All Products
Get list of products with optional filters.

**Endpoint:** `GET /products`  
**Authentication:** Not required

**Query Parameters:**
- `category_id` (optional) - Filter by category ID
- `featured` (optional) - Filter featured products (true/false)
- `search` (optional) - Search by product name
- `page` (optional) - Page number for pagination
- `per_page` (optional) - Items per page (default: 15)

**Example:** `/products?category_id=1&featured=true&per_page=10`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "category_id": 1,
      "name": "Kulhad Chai",
      "description": "Traditional Indian tea served in earthen kulhad",
      "base_price": "50.00",
      "image": "url",
      "is_featured": true,
      "is_available": true,
      "sort_order": 1,
      "category": {
        "id": 1,
        "name": "Kulhad Tea",
        "icon": "url"
      },
      "sizes": [
        {
          "id": 1,
          "product_id": 1,
          "name": "Small",
          "price": "50.00",
          "is_available": true
        },
        {
          "id": 2,
          "product_id": 1,
          "name": "Medium",
          "price": "70.00",
          "is_available": true
        },
        {
          "id": 3,
          "product_id": 1,
          "name": "Large",
          "price": "90.00",
          "is_available": true
        }
      ],
      "variants": [
        {
          "id": 1,
          "product_id": 1,
          "name": "Extra Sugar",
          "price": "5.00",
          "image": "url",
          "is_available": true
        }
      ]
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 15,
    "total": 6
  }
}
```

### Get Product Details
Get detailed information about a specific product.

**Endpoint:** `GET /products/{id}`  
**Authentication:** Not required

**Response:**
```json
{
  "data": {
    "id": 1,
    "name": "Kulhad Chai",
    "description": "Traditional Indian tea served in earthen kulhad",
    "base_price": "50.00",
    "image": "url",
    "category": { ... },
    "sizes": [ ... ],
    "variants": [ ... ]
  }
}
```

---

## 🛒 Cart

### Get Cart
Get current user's cart items with calculated totals.

**Endpoint:** `GET /cart`  
**Authentication:** Required

**Response:**
```json
{
  "data": {
    "items": [
      {
        "id": 1,
        "product_id": 1,
        "product_name": "Kulhad Chai",
        "product_image": "url",
        "size_id": 2,
        "size_name": "Medium",
        "quantity": 2,
        "base_price": "70.00",
        "variants": [
          {
            "variant_id": 1,
            "variant_name": "Extra Sugar",
            "price": "5.00"
          }
        ],
        "item_total": "150.00"
      }
    ],
    "subtotal": "150.00",
    "tax": "7.50",
    "delivery_fee": "20.00",
    "total": "177.50"
  }
}
```

### Add to Cart
Add a product with size and variants to cart.

**Endpoint:** `POST /cart/add`  
**Authentication:** Required

**Request Body:**
```json
{
  "product_id": 1,
  "size_id": 2,
  "quantity": 1,
  "variant_ids": [1, 2]
}
```

**Validation:**
- `product_id` - required, must exist in products table
- `size_id` - required, must exist in product_sizes table
- `quantity` - required, integer, minimum 1
- `variant_ids` - optional, array of variant IDs

**Response:**
```json
{
  "message": "Item added to cart",
  "data": {
    "cart_item_id": 1,
    "cart_count": 3
  }
}
```

### Update Cart Item
Update quantity of a cart item.

**Endpoint:** `PUT /cart/{itemId}`  
**Authentication:** Required

**Request Body:**
```json
{
  "quantity": 3
}
```

**Response:**
```json
{
  "message": "Cart item updated",
  "data": {
    "id": 1,
    "quantity": 3
  }
}
```

### Remove from Cart
Remove a specific item from cart.

**Endpoint:** `DELETE /cart/{itemId}`  
**Authentication:** Required

**Response:**
```json
{
  "message": "Item removed from cart"
}
```

### Clear Cart
Remove all items from cart.

**Endpoint:** `DELETE /cart/clear/all`  
**Authentication:** Required

**Response:**
```json
{
  "message": "Cart cleared"
}
```

---

## 📦 Orders

### Create Order
Create a new order from cart items.

**Endpoint:** `POST /orders`  
**Authentication:** Required

**Request Body:**
```json
{
  "payment_method": "upi",
  "delivery_address_id": 1,
  "special_instructions": "Less sugar please"
}
```

**Validation:**
- `payment_method` - required, string (upi, card, cash)
- `delivery_address_id` - required, must exist and belong to user
- `special_instructions` - optional, string

**Response:**
```json
{
  "data": {
    "order_id": "ORD-67740A1C89ABC",
    "total": "177.50",
    "status": "pending",
    "payment_url": null
  }
}
```

**Note:** Cart is automatically cleared after order creation.

### Get Orders
Get list of user's orders.

**Endpoint:** `GET /orders`  
**Authentication:** Required

**Query Parameters:**
- `status` (optional) - Filter by status (pending, confirmed, preparing, ready, delivered, cancelled)
- `page` (optional) - Page number
- `per_page` (optional) - Items per page (default: 15)

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "order_number": "ORD-67740A1C89ABC",
      "subtotal": "150.00",
      "tax": "7.50",
      "delivery_fee": "20.00",
      "total": "177.50",
      "status": "pending",
      "payment_method": "upi",
      "payment_status": "pending",
      "created_at": "2025-12-26T07:31:36.000000Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 1,
    "per_page": 15,
    "total": 1
  }
}
```

### Get Order Details
Get detailed information about a specific order.

**Endpoint:** `GET /orders/{orderNumber}`  
**Authentication:** Required

**Response:**
```json
{
  "data": {
    "id": 1,
    "order_number": "ORD-67740A1C89ABC",
    "status": "pending",
    "items": [
      {
        "id": 1,
        "product_id": 1,
        "product_name": "Kulhad Chai",
        "product_image": "url",
        "size_name": "Medium",
        "size_price": "70.00",
        "quantity": 2,
        "variants": [
          {
            "variant_name": "Extra Sugar",
            "variant_price": "5.00"
          }
        ],
        "item_total": "150.00"
      }
    ],
    "subtotal": "150.00",
    "tax": "7.50",
    "delivery_fee": "20.00",
    "total": "177.50",
    "payment_method": "upi",
    "payment_status": "pending",
    "delivery_address": {
      "id": 1,
      "label": "Home",
      "address_line1": "123 Street",
      "city": "Mumbai",
      "state": "Maharashtra",
      "pincode": "400001"
    },
    "special_instructions": "Less sugar please",
    "created_at": "2025-12-26T07:31:36.000000Z",
    "estimated_delivery_time": "2025-12-26T08:01:36.000000Z"
  }
}
```

---

## 📍 Addresses

### Get Addresses
Get all user's addresses.

**Endpoint:** `GET /addresses`  
**Authentication:** Required

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "label": "Home",
      "address_line1": "123 Street",
      "address_line2": "Near Park",
      "city": "Mumbai",
      "state": "Maharashtra",
      "pincode": "400001",
      "is_default": true,
      "created_at": "2025-12-26T07:31:36.000000Z",
      "updated_at": "2025-12-26T07:31:36.000000Z"
    }
  ]
}
```

### Create Address
Add a new delivery address.

**Endpoint:** `POST /addresses`  
**Authentication:** Required

**Request Body:**
```json
{
  "label": "Home",
  "address_line1": "123 Street",
  "address_line2": "Near Park",
  "city": "Mumbai",
  "state": "Maharashtra",
  "pincode": "400001",
  "is_default": true
}
```

**Validation:**
- `label` - required, string, max 50 characters
- `address_line1` - required, string, max 255 characters
- `address_line2` - optional, string, max 255 characters
- `city` - required, string, max 100 characters
- `state` - required, string, max 100 characters
- `pincode` - required, string, max 20 characters
- `is_default` - optional, boolean

**Response:**
```json
{
  "message": "Address created successfully",
  "data": {
    "id": 1,
    "label": "Home",
    "address_line1": "123 Street",
    "is_default": true
  }
}
```

### Get Single Address
Get details of a specific address.

**Endpoint:** `GET /addresses/{id}`  
**Authentication:** Required

**Response:**
```json
{
  "data": {
    "id": 1,
    "label": "Home",
    "address_line1": "123 Street",
    "city": "Mumbai",
    "is_default": true
  }
}
```

### Update Address
Update an existing address.

**Endpoint:** `PUT /addresses/{id}`  
**Authentication:** Required

**Request Body:** (all fields optional)
```json
{
  "label": "Work",
  "address_line1": "456 Avenue",
  "city": "Delhi",
  "is_default": false
}
```

**Response:**
```json
{
  "message": "Address updated successfully",
  "data": {
    "id": 1,
    "label": "Work"
  }
}
```

### Delete Address
Delete an address.

**Endpoint:** `DELETE /addresses/{id}`  
**Authentication:** Required

**Response:**
```json
{
  "message": "Address deleted successfully"
}
```

---

## 🔐 Error Responses

All endpoints may return the following error responses:

### 401 Unauthorized
```json
{
  "message": "Unauthenticated."
}
```

### 404 Not Found
```json
{
  "message": "Resource not found"
}
```

### 422 Validation Error
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "product_id": [
      "The product id field is required."
    ]
  }
}
```

### 500 Server Error
```json
{
  "message": "Failed to process request",
  "error": "Error details"
}
```

---

## 📊 Database Schema

### Tables Created:
1. **categories** - Product categories
2. **products** - Product catalog
3. **product_sizes** - Product size options
4. **product_variants** - Product add-ons/variants
5. **addresses** - User delivery addresses
6. **cart_items** - Shopping cart items
7. **cart_item_variants** - Cart item variants
8. **orders** - Order records
9. **order_items** - Order line items
10. **order_item_variants** - Order item variants

---

## 🚀 Testing the API

### Using cURL:

**Get Products:**
```bash
curl -X GET http://localhost:8000/api/products
```

**Add to Cart:**
```bash
curl -X POST http://localhost:8000/api/cart/add \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": 1,
    "size_id": 2,
    "quantity": 1,
    "variant_ids": [1]
  }'
```

**Create Order:**
```bash
curl -X POST http://localhost:8000/api/orders \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "payment_method": "upi",
    "delivery_address_id": 1
  }'
```

---

## 📝 Notes

1. **Authentication:** Most endpoints require Sanctum token. Get token from login/register endpoints.

2. **Pricing:** All prices are stored and returned as decimals with 2 decimal places.

3. **Cart Logic:** 
   - Cart automatically calculates totals including variants
   - Tax is 5% of subtotal
   - Delivery fee is fixed at ₹20

4. **Order Creation:**
   - Validates cart is not empty
   - Verifies address belongs to user
   - Takes snapshot of product prices at order time
   - Clears cart after successful order creation

5. **Default Address:**
   - Setting an address as default automatically removes default flag from other addresses

6. **Product Availability:**
   - Only available products are returned in listings
   - Unavailable products return 400 error when adding to cart

---

## 🔄 Order Status Flow

```
pending → confirmed → preparing → ready → delivered
                        ↓
                    cancelled
```

## 💳 Payment Methods

Supported payment methods:
- `upi` - UPI payment
- `card` - Credit/Debit card
- `cash` - Cash on delivery

---

## 📞 Support

For API issues or questions, please refer to the main project repository.
