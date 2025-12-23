# Gaon Wali Chai - New UI & Backend Comprehensive Plan

## 📱 UI Screens Analysis (Based on Reference Images)

### 1. **Home Screen**
**Visual Elements:**
- Top section with user greeting and location
- Featured/Hero banner with promotional content
- Category chips/buttons (Kulhad Tea, Snacks, Desserts, Drinks)
- "Featured Products" section with horizontal scrollable cards
- Bottom navigation bar (Home, Menu, Cart, Orders, Profile)

**Components Needed:**
```dart
- HomeScreen (main container)
- AppBarCustom (with greeting, notifications, location)
- PromoBanner (hero section with image/animation)
- CategoryChipsRow (horizontal scrollable categories)
- FeaturedProductsSection
  - ProductCard (reusable component)
    - Product image
    - Product name
    - Price
    - Add to cart button
- BottomNavigationBar (global)
```

**State Management:**
- User profile data
- Featured products list
- Categories list
- Cart count (badge)

---

### 2. **Menu Screen**
**Visual Elements:**
- Category tabs at top (Hot, Kulhad Chai, SHAKE, DESSERTS, etc.)
- Grid layout of products (2 columns)
- Each product card shows:
  - Product image
  - Product name
  - Price
  - Add button

**Components Needed:**
```dart
- MenuScreen
- CategoryTabBar (horizontal scrollable tabs)
- ProductGridView
  - ProductGridCard
    - Product image (with rounded corners)
    - Product name
    - Price tag
    - Add to cart icon button
- FilterButton (optional)
```

**State Management:**
- Selected category
- Products list filtered by category
- Cart state

---

### 3. **Single Product Screen**
**Visual Elements:**
- Large product image at top (with back button overlay)
- Product name and price
- Size selector (Small, Medium, Large buttons)
- Product description
- Variant options section
  - List of add-ons with names, images, prices
  - Checkbox/toggle for each variant
- Total price display
- "Add to Cart" button (sticky bottom)

**Components Needed:**
```dart
- ProductDetailScreen
- ProductImageHero (with zoom capability)
- ProductInfoCard
  - Product name
  - Base price
- SizeSelector (toggle buttons)
- ProductDescription
- VariantsList
  - VariantItem
    - Variant image
    - Variant name
    - Variant price
    - Checkbox/Counter
- PriceBreakdown (showing calculation)
- AddToCartButton (sticky)
```

**State Management:**
- Product details
- Selected size
- Selected variants/add-ons
- Quantity
- Calculated total price

---

### 4. **Cart Screen**
**Visual Elements:**
- "CART" header with back button
- List of cart items:
  - Product image
  - Product name
  - Variant info
  - Price
  - Quantity (no visible stepper in reference, just display)
- Subtotal breakdown
- "Continue Payment" button
- "Yes, Remove" confirmation dialog

**Components Needed:**
```dart
- CartScreen
- CartItemsList
  - CartItemCard
    - Product thumbnail
    - Product details
    - Price
    - Quantity badge
    - Remove button
- RemoveItemDialog (confirmation)
- PricingSummary
  - Subtotal
  - Taxes/Fees (if any)
  - Total
- ContinueButton
```

**State Management:**
- Cart items array
- Cart totals
- Remove confirmation state

---

### 5. **Payment Method Screen**
**Visual Elements:**
- "PAYMENT METHOD" header
- Payment method cards:
  - UPI option (with icon)
  - Credit/Debit Card option (with icon)
  - Radio button selection
- Order summary at bottom
- "Confirm Payment" button

**Components Needed:**
```dart
- PaymentMethodScreen
- PaymentMethodCard (reusable)
  - Payment icon
  - Payment type name
  - Radio button
- OrderSummaryCard
  - Items summary
  - Total amount
- ConfirmPaymentButton
```

**State Management:**
- Selected payment method
- Order details
- Payment processing state

---

### 6. **Order Placed Screen**
**Visual Elements:**
- Large success icon/animation (checkmark)
- "GaonWali Chai" branding
- "Your Order Placed Successfully!" message
- Bottom navigation (visible)

**Components Needed:**
```dart
- OrderSuccessScreen
- SuccessAnimation (Lottie or custom)
- SuccessMessage
- ViewOrderButton (navigate to order details)
- ContinueShoppingButton
```

---

## 🎨 Design System

### Color Palette (Based on Images)
```dart
class AppColors {
  // Primary colors
  static const primary = Color(0xFF8B4513); // Brown
  static const primaryLight = Color(0xFFD2A679); // Light brown/beige
  static const primaryDark = Color(0xFF5C2E0A); // Dark brown
  
  // Secondary colors
  static const secondary = Color(0xFFF5E6D3); // Cream/beige
  static const accent = Color(0xFFFF8C42); // Orange accent
  
  // Background
  static const background = Color(0xFFFFF8F0); // Light cream
  static const cardBackground = Color(0xFFFFFFFF);
  
  // Text
  static const textPrimary = Color(0xFF2D1810);
  static const textSecondary = Color(0xFF8B7355);
  static const textLight = Color(0xFFFFFFFF);
  
  // UI Elements
  static const border = Color(0xFFE8D5C4);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);
}
```

### Typography
```dart
class AppTypography {
  static const fontFamily = 'Poppins'; // or similar rounded font
  
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
  
  static const price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );
}
```

### Component Styles
```dart
// Buttons
- Primary Button: Rounded, dark brown background, white text
- Secondary Button: Outlined, transparent background, dark brown text
- Icon Button: Circular, with icon

// Cards
- Elevation: 2-4
- Border Radius: 12-16
- Background: White or cream

// Input Fields
- Border Radius: 8-12
- Border: 1px light brown
- Focus: Accent color border
```

---

## 🏗️ Backend API Requirements

### 1. **Product Management APIs**

#### Get All Products
```
GET /api/products
Query Params: 
  - category_id (optional)
  - featured (boolean, optional)
  - search (string, optional)
  - page, per_page (pagination)

Response:
{
  "data": [
    {
      "id": 1,
      "name": "Kulhad Chai",
      "description": "Traditional Indian tea served in kulhad",
      "base_price": 50,
      "image": "url",
      "category": {
        "id": 1,
        "name": "Hot Drinks"
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
          "price": 70
        },
        {
          "id": 3,
          "name": "Large",
          "price": 90
        }
      ],
      "is_featured": true,
      "is_available": true
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 50
  }
}
```

#### Get Product Details
```
GET /api/products/{id}

Response:
{
  "data": {
    "id": 1,
    "name": "Kulhad Chai",
    "description": "Traditional Indian tea...",
    "base_price": 50,
    "image": "url",
    "category": {...},
    "sizes": [...],
    "variants": [
      {
        "id": 1,
        "name": "Extra Sugar",
        "price": 5,
        "image": "url"
      },
      {
        "id": 2,
        "name": "Elaichi",
        "price": 10,
        "image": "url"
      }
    ]
  }
}
```

---

### 2. **Category APIs**

#### Get All Categories
```
GET /api/categories

Response:
{
  "data": [
    {
      "id": 1,
      "name": "Kulhad Tea",
      "icon": "url",
      "sort_order": 1
    }
  ]
}
```

---

### 3. **Cart APIs**

#### Get Cart
```
GET /api/cart

Response:
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
        "base_price": 70,
        "variants": [
          {
            "variant_id": 1,
            "variant_name": "Extra Sugar",
            "price": 5
          }
        ],
        "item_total": 150
      }
    ],
    "subtotal": 150,
    "tax": 15,
    "delivery_fee": 20,
    "total": 185
  }
}
```

#### Add to Cart
```
POST /api/cart/add

Request:
{
  "product_id": 1,
  "size_id": 2,
  "quantity": 1,
  "variant_ids": [1, 2]
}

Response:
{
  "message": "Item added to cart",
  "data": {
    "cart_item_id": 1,
    "cart_count": 3
  }
}
```

#### Update Cart Item
```
PUT /api/cart/{item_id}

Request:
{
  "quantity": 3
}
```

#### Remove from Cart
```
DELETE /api/cart/{item_id}

Response:
{
  "message": "Item removed from cart"
}
```

#### Clear Cart
```
DELETE /api/cart/clear
```

---

### 4. **Order APIs**

#### Create Order
```
POST /api/orders

Request:
{
  "payment_method": "upi",
  "delivery_address_id": 1,
  "special_instructions": "Less sugar please"
}

Response:
{
  "data": {
    "order_id": "ORD-123456",
    "total": 185,
    "status": "pending",
    "payment_url": "url" // for UPI/card payment
  }
}
```

#### Get Order Details
```
GET /api/orders/{order_id}

Response:
{
  "data": {
    "id": 1,
    "order_number": "ORD-123456",
    "status": "pending|confirmed|preparing|ready|delivered|cancelled",
    "items": [...],
    "subtotal": 150,
    "tax": 15,
    "delivery_fee": 20,
    "total": 185,
    "payment_method": "upi",
    "payment_status": "pending|completed|failed",
    "delivery_address": {...},
    "created_at": "timestamp",
    "estimated_delivery_time": "timestamp"
  }
}
```

#### Get User Orders
```
GET /api/orders
Query Params:
  - status (optional)
  - page, per_page

Response:
{
  "data": [
    {
      "id": 1,
      "order_number": "ORD-123456",
      "total": 185,
      "status": "delivered",
      "created_at": "timestamp"
    }
  ]
}
```

---

### 5. **User Profile APIs**

#### Get Profile
```
GET /api/profile

Response:
{
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+91-9876543210",
    "avatar": "url",
    "addresses": [...]
  }
}
```

#### Update Profile
```
PUT /api/profile

Request:
{
  "name": "John Doe",
  "phone": "+91-9876543210"
}
```

---

### 6. **Address APIs**

#### Get Addresses
```
GET /api/addresses
```

#### Add Address
```
POST /api/addresses

Request:
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

#### Update Address
```
PUT /api/addresses/{id}
```

#### Delete Address
```
DELETE /api/addresses/{id}
```

---

## 🗄️ Database Schema Updates

### Tables to Create/Modify

#### 1. **products** table
```sql
CREATE TABLE products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_id BIGINT,
    name VARCHAR(255),
    description TEXT,
    base_price DECIMAL(10, 2),
    image VARCHAR(255),
    is_featured BOOLEAN DEFAULT false,
    is_available BOOLEAN DEFAULT true,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
```

#### 2. **categories** table
```sql
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    icon VARCHAR(255),
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

#### 3. **product_sizes** table
```sql
CREATE TABLE product_sizes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT,
    name VARCHAR(50), -- Small, Medium, Large
    price DECIMAL(10, 2),
    is_available BOOLEAN DEFAULT true,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
```

#### 4. **product_variants** table (add-ons)
```sql
CREATE TABLE product_variants (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT,
    name VARCHAR(255), -- Extra Sugar, Elaichi, etc.
    price DECIMAL(10, 2),
    image VARCHAR(255),
    is_available BOOLEAN DEFAULT true,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
```

#### 5. **cart_items** table
```sql
CREATE TABLE cart_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    product_id BIGINT,
    size_id BIGINT,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (size_id) REFERENCES product_sizes(id)
);
```

#### 6. **cart_item_variants** table
```sql
CREATE TABLE cart_item_variants (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cart_item_id BIGINT,
    variant_id BIGINT,
    FOREIGN KEY (cart_item_id) REFERENCES cart_items(id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(id)
);
```

#### 7. **orders** table
```sql
CREATE TABLE orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    order_number VARCHAR(50) UNIQUE,
    subtotal DECIMAL(10, 2),
    tax DECIMAL(10, 2),
    delivery_fee DECIMAL(10, 2),
    total DECIMAL(10, 2),
    status ENUM('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled'),
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'completed', 'failed'),
    delivery_address_id BIGINT,
    special_instructions TEXT,
    estimated_delivery_time TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (delivery_address_id) REFERENCES addresses(id)
);
```

#### 8. **order_items** table
```sql
CREATE TABLE order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT,
    product_id BIGINT,
    product_name VARCHAR(255), -- snapshot
    product_image VARCHAR(255), -- snapshot
    size_name VARCHAR(50),
    size_price DECIMAL(10, 2),
    quantity INT,
    item_total DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
```

#### 9. **order_item_variants** table
```sql
CREATE TABLE order_item_variants (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_item_id BIGINT,
    variant_name VARCHAR(255),
    variant_price DECIMAL(10, 2),
    FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE
);
```

#### 10. **addresses** table
```sql
CREATE TABLE addresses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    label VARCHAR(50), -- Home, Work, etc.
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(20),
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## 📱 Flutter Project Structure

```
lib/
  main.dart
  
  core/
    config/
      theme/
        app_colors.dart
        app_typography.dart
        app_theme.dart
    constants/
      api_constants.dart
      app_constants.dart
    utils/
      helpers.dart
      validators.dart
    
  features/
    home/
      data/
        models/
          featured_product_model.dart
        repositories/
          home_repository.dart
      presentation/
        screens/
          home_screen.dart
        widgets/
          promo_banner.dart
          category_chips.dart
          featured_products_section.dart
      
    menu/
      data/
        models/
          category_model.dart
          product_model.dart
        repositories/
          product_repository.dart
      presentation/
        screens/
          menu_screen.dart
          product_detail_screen.dart
        widgets/
          category_tab_bar.dart
          product_grid_card.dart
          size_selector.dart
          variant_item.dart
    
    cart/
      data/
        models/
          cart_model.dart
          cart_item_model.dart
        repositories/
          cart_repository.dart
      presentation/
        screens/
          cart_screen.dart
        widgets/
          cart_item_card.dart
          pricing_summary.dart
    
    orders/
      data/
        models/
          order_model.dart
          order_item_model.dart
        repositories/
          order_repository.dart
      presentation/
        screens/
          orders_screen.dart
          order_detail_screen.dart
          order_success_screen.dart
        widgets/
          order_card.dart
    
    payment/
      presentation/
        screens/
          payment_method_screen.dart
        widgets/
          payment_method_card.dart
    
    profile/
      data/
        models/
          address_model.dart
        repositories/
          profile_repository.dart
      presentation/
        screens/
          profile_screen.dart
          addresses_screen.dart
          add_address_screen.dart
        widgets/
          address_card.dart
  
  shared/
    widgets/
      custom_app_bar.dart
      custom_button.dart
      custom_text_field.dart
      loading_indicator.dart
      error_widget.dart
      product_card.dart
      bottom_nav_bar.dart
```

---

## 🔧 Implementation Phases

### **Phase 1: Setup & Core Components (Week 1)**
1. ✅ Setup design system (colors, typography, theme)
2. ✅ Create reusable widgets (buttons, cards, inputs)
3. ✅ Setup bottom navigation
4. ✅ Create base screen structure

### **Phase 2: Home & Menu (Week 2)**
1. ✅ Implement Home screen UI
2. ✅ Create category chips
3. ✅ Build featured products section
4. ✅ Implement Menu screen with categories
5. ✅ Create product grid view
6. ✅ Backend: Products & Categories APIs

### **Phase 3: Product Details & Cart (Week 3)**
1. ✅ Product detail screen with size selector
2. ✅ Variants/add-ons selection
3. ✅ Cart screen UI
4. ✅ Add/remove cart functionality
5. ✅ Backend: Cart APIs
6. ✅ Backend: Product sizes & variants

### **Phase 4: Orders & Payment (Week 4)**
1. ✅ Payment method screen
2. ✅ Order creation flow
3. ✅ Order success screen
4. ✅ Orders history screen
5. ✅ Backend: Orders APIs
6. ✅ Payment gateway integration

### **Phase 5: Profile & Polish (Week 5)**
1. ✅ Profile screen
2. ✅ Address management
3. ✅ Animations & transitions
4. ✅ Error handling & loading states
5. ✅ Testing & bug fixes

---

## 🎯 Key Features to Implement

### Frontend
- [ ] Bottom navigation with cart badge
- [ ] Product search functionality
- [ ] Product filtering by category
- [ ] Size and variant selection with price calculation
- [ ] Cart management (add, update, remove)
- [ ] Order placement flow
- [ ] Order tracking
- [ ] Address management
- [ ] Payment integration
- [ ] Pull-to-refresh on list screens
- [ ] Skeleton loaders
- [ ] Empty states
- [ ] Error handling with retry

### Backend
- [ ] Product management APIs
- [ ] Category management
- [ ] Cart APIs with authentication
- [ ] Order creation and tracking
- [ ] Payment gateway integration (Razorpay/Stripe)
- [ ] Push notifications for order updates
- [ ] Admin panel for product/order management
- [ ] Image upload and optimization
- [ ] Search and filtering
- [ ] Inventory management

---

## 🔐 Security Considerations

1. **Authentication**: Use Sanctum tokens (already implemented)
2. **Cart Security**: Validate prices on backend, don't trust frontend
3. **Order Validation**: Re-calculate totals on backend before order creation
4. **Payment Security**: Use secure payment gateway, never store card details
5. **API Rate Limiting**: Implement rate limiting on all APIs
6. **Input Validation**: Validate all inputs on backend
7. **HTTPS Only**: Ensure all API calls use HTTPS

---

## 📊 State Management Recommendation

Use **Provider** or **Riverpod** for state management:

```dart
// Example structure
providers/
  auth_provider.dart
  cart_provider.dart
  products_provider.dart
  orders_provider.dart
```

Key states to manage:
- User authentication state
- Cart state (items, count, total)
- Product list state
- Order history state
- Loading states
- Error states

---

## 🚀 Next Steps

1. **Review and approve this plan**
2. **Setup design system and theme**
3. **Create database migrations**
4. **Build core reusable widgets**
5. **Start with Home screen implementation**
6. **Implement APIs in parallel with UI**
7. **Testing each feature before moving to next**

---

## 📝 Notes

- All prices should be stored in smallest currency unit (paise) in database
- Images should be optimized and cached
- Implement offline mode for viewing previously loaded products
- Add analytics tracking for user behavior
- Implement deep linking for product sharing
- Add social login (Google, Facebook) alongside existing auth
- Consider adding loyalty points/rewards system in future
