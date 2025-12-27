# 🛒 Checkout & Payment System Implementation Plan
## Gaon Wali Chai - Razorpay Integration

---

## 📋 Table of Contents
1. [Overview](#overview)
2. [Current Status](#current-status)
3. [Architecture](#architecture)
4. [Phase 1: Address Management](#phase-1-address-management)
5. [Phase 2: Checkout Flow](#phase-2-checkout-flow)
6. [Phase 3: Razorpay Integration](#phase-3-razorpay-integration)
7. [Phase 4: Order Management](#phase-4-order-management)
8. [Implementation Checklist](#implementation-checklist)

---

## 🎯 Overview

### Why Razorpay?
✅ **Best Payment Gateway for India**
- Supports UPI, Cards, Wallets, Net Banking
- Easy integration with Flutter & Laravel
- Excellent documentation
- Low transaction fees (2% + GST)
- Instant settlement options
- PCI DSS compliant
- Great developer support

### Alternative Options Considered
- **Paytm**: Complex integration, higher fees
- **PhonePe**: Limited to UPI only
- **Stripe**: Better for international, but Razorpay better for India
- **Cash on Delivery**: Can be added as fallback

---

## 📊 Current Status

### ✅ Already Implemented (Backend)
- ✅ Order model & database schema
- ✅ OrderController with create/show/index methods
- ✅ Address model & AddressController
- ✅ Order creation from cart
- ✅ Price calculation (subtotal, tax, delivery fee)
- ✅ Order status tracking
- ✅ Cart clearing after order

### ✅ Already Implemented (Flutter)
- ✅ Order models (OrderModel, OrderItemModel)
- ✅ Order repository & API service
- ✅ Address models
- ✅ Address repository (ready but unused)
- ✅ Cart screen with "Proceed to Checkout" button

### ❌ Missing (Need to Implement)
- ❌ Address management screens
- ❌ Checkout flow screens
- ❌ Payment gateway integration
- ❌ Order success/failure screens
- ❌ Order tracking screens

---

## 🏗️ Architecture

### Data Flow
```
Cart Screen
    ↓
Checkout Screen
    ↓
Address Selection → [Manage Addresses]
    ↓
Payment Method Selection
    ↓
Order Summary Review
    ↓
Place Order → Backend
    ↓
Create Order → Get Razorpay Order ID
    ↓
Open Razorpay Payment → User Pays
    ↓
Payment Success/Failure
    ↓
Update Order Status
    ↓
Order Success Screen / Order Failed Screen
```

### Backend Architecture
```
OrderController
    ↓
Create Order → Generate Order Number
    ↓
Create Razorpay Order → Get order_id
    ↓
Return order_id to Flutter
    ↓
After Payment → Webhook
    ↓
Update payment_status
    ↓
Send confirmation (optional: SMS/Email)
```

---

## 📱 Phase 1: Address Management
**Priority: HIGH** (Required before checkout)

### 1.1 Address List Screen
**File**: `lib/features/profile/presentation/screens/addresses_screen.dart`

**Features:**
- Display all saved addresses
- Mark default address
- Add new address button
- Edit/Delete existing addresses
- Empty state for no addresses

**UI Components:**
```dart
- AppBar with "Delivery Addresses" title
- AddressCard widget for each address
  - Label (Home, Work, Other)
  - Full address display
  - Default badge
  - Edit/Delete icons
- FloatingActionButton to add new address
- EmptyStateWidget when no addresses
```

**State Management:**
- Use AddressRepository to fetch addresses
- Provider/setState for local state
- Refresh after add/edit/delete

---

### 1.2 Add/Edit Address Screen
**File**: `lib/features/profile/presentation/screens/add_edit_address_screen.dart`

**Form Fields:**
- Label dropdown (Home, Work, Other)
- Address Line 1 (required)
- Address Line 2 (optional)
- City (required)
- State dropdown (required)
- Pincode (required, numeric validation)
- Set as default checkbox

**Validation:**
- All required fields
- Pincode: 6 digits numeric
- No empty spaces

**Actions:**
- Save button → Create/Update via AddressRepository
- Cancel button → Go back
- Show loading during API call

---

## 🛒 Phase 2: Checkout Flow

### 2.1 Checkout Screen
**File**: `lib/features/checkout/presentation/screens/checkout_screen.dart`

**Sections:**

#### A) Cart Summary (Top)
- List of cart items (non-editable view)
- Item count
- "Edit Cart" link → Navigate back to cart

#### B) Delivery Address Section
- Selected address display card
- "Change Address" button → Open address selection bottom sheet
- "Add New Address" if no addresses exist

#### C) Payment Method Section
- Radio buttons:
  - 💳 UPI (Recommended)
  - 💳 Credit/Debit Card
  - 💵 Cash on Delivery (optional)
- Selected method highlighted

#### D) Order Summary Section
- Subtotal: ₹XXX
- Delivery Fee: ₹20
- Tax (5%): ₹XX
- **Total: ₹XXX** (bold, large)

#### E) Place Order Button
- Full-width button at bottom
- Shows "Place Order ₹XXX"
- Disabled if no address selected
- Loading state during order creation

**Flow:**
```dart
1. Load cart items from CartProvider
2. Check if user has addresses
   - If no: Navigate to Add Address
   - If yes: Show first/default address
3. Select payment method (default: UPI)
4. Tap "Place Order"
   - Show loading
   - Call OrderRepository.createOrder()
   - If success: Navigate to payment
   - If error: Show error message
```

---

### 2.2 Address Selection Bottom Sheet
**File**: `lib/features/checkout/presentation/widgets/address_selection_sheet.dart`

**Features:**
- List all addresses
- Radio button for selection
- Selected address highlighted
- "Add New Address" button at bottom
- "Confirm" button

**Behavior:**
- Open as modal bottom sheet
- Returns selected address to checkout screen
- Dismiss on confirm or outside tap

---

## 💳 Phase 3: Razorpay Integration

### 3.1 Backend Setup

#### Install Razorpay PHP SDK
```bash
cd gaon_wali_chai_api
composer require razorpay/razorpay
```

#### Create Razorpay Config
**File**: `config/razorpay.php`
```php
<?php
return [
    'key_id' => env('RAZORPAY_KEY_ID'),
    'key_secret' => env('RAZORPAY_KEY_SECRET'),
    'webhook_secret' => env('RAZORPAY_WEBHOOK_SECRET'),
];
```

#### Update .env
```
RAZORPAY_KEY_ID=rzp_test_XXXXX
RAZORPAY_KEY_SECRET=XXXXX
RAZORPAY_WEBHOOK_SECRET=XXXXX
```

#### Create Payment Service
**File**: `app/Services/PaymentService.php`
```php
<?php

namespace App\Services;

use Razorpay\Api\Api;
use App\Models\Order;

class PaymentService
{
    protected $api;

    public function __construct()
    {
        $this->api = new Api(
            config('razorpay.key_id'),
            config('razorpay.key_secret')
        );
    }

    /**
     * Create Razorpay order
     */
    public function createOrder(Order $order)
    {
        $razorpayOrder = $this->api->order->create([
            'amount' => $order->total * 100, // Amount in paise
            'currency' => 'INR',
            'receipt' => $order->order_number,
            'notes' => [
                'order_id' => $order->id,
                'user_id' => $order->user_id,
            ]
        ]);

        return [
            'razorpay_order_id' => $razorpayOrder['id'],
            'amount' => $razorpayOrder['amount'],
            'currency' => $razorpayOrder['currency'],
        ];
    }

    /**
     * Verify payment signature
     */
    public function verifyPayment($razorpayOrderId, $razorpayPaymentId, $razorpaySignature)
    {
        try {
            $attributes = [
                'razorpay_order_id' => $razorpayOrderId,
                'razorpay_payment_id' => $razorpayPaymentId,
                'razorpay_signature' => $razorpaySignature
            ];

            $this->api->utility->verifyPaymentSignature($attributes);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Get payment details
     */
    public function getPaymentDetails($paymentId)
    {
        return $this->api->payment->fetch($paymentId);
    }
}
```

#### Update OrderController
**File**: `app/Http/Controllers/OrderController.php`

Add to store() method after order creation:
```php
use App\Services\PaymentService;

// After creating order...

// Create Razorpay order (only for online payments)
$razorpayData = null;
if (in_array($request->payment_method, ['upi', 'card', 'online'])) {
    $paymentService = new PaymentService();
    $razorpayData = $paymentService->createOrder($order);
    
    // Store Razorpay order ID
    $order->update([
        'razorpay_order_id' => $razorpayData['razorpay_order_id']
    ]);
}

return response()->json([
    'data' => [
        'order_id' => $order->order_number,
        'order_db_id' => $order->id,
        'total' => $order->total,
        'status' => $order->status,
        'razorpay_data' => $razorpayData,
        'razorpay_key' => config('razorpay.key_id'),
    ]
], 201);
```

#### Add Migration for Razorpay Fields
```bash
php artisan make:migration add_razorpay_fields_to_orders_table
```

```php
public function up()
{
    Schema::table('orders', function (Blueprint $table) {
        $table->string('razorpay_order_id')->nullable()->after('payment_status');
        $table->string('razorpay_payment_id')->nullable()->after('razorpay_order_id');
        $table->string('razorpay_signature')->nullable()->after('razorpay_payment_id');
    });
}
```

#### Create Payment Verification Endpoint
**File**: `app/Http/Controllers/PaymentController.php`
```php
<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Services\PaymentService;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    protected $paymentService;

    public function __construct(PaymentService $paymentService)
    {
        $this->paymentService = $paymentService;
    }

    /**
     * Verify payment and update order
     */
    public function verifyPayment(Request $request)
    {
        $request->validate([
            'razorpay_order_id' => 'required',
            'razorpay_payment_id' => 'required',
            'razorpay_signature' => 'required',
            'order_id' => 'required|exists:orders,id',
        ]);

        $verified = $this->paymentService->verifyPayment(
            $request->razorpay_order_id,
            $request->razorpay_payment_id,
            $request->razorpay_signature
        );

        if ($verified) {
            $order = Order::findOrFail($request->order_id);
            $order->update([
                'payment_status' => 'completed',
                'razorpay_payment_id' => $request->razorpay_payment_id,
                'razorpay_signature' => $request->razorpay_signature,
                'status' => 'confirmed',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Payment verified successfully',
                'order' => $order,
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Payment verification failed'
        ], 400);
    }

    /**
     * Handle payment failure
     */
    public function paymentFailed(Request $request)
    {
        $request->validate([
            'order_id' => 'required|exists:orders,id',
            'error_code' => 'nullable',
            'error_description' => 'nullable',
        ]);

        $order = Order::findOrFail($request->order_id);
        $order->update([
            'payment_status' => 'failed',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Payment failure recorded',
        ]);
    }
}
```

#### Add Routes
**File**: `routes/api.php`
```php
use App\Http\Controllers\PaymentController;

Route::middleware('auth:sanctum')->group(function () {
    // ... existing routes

    // Payment routes
    Route::prefix('payment')->group(function () {
        Route::post('/verify', [PaymentController::class, 'verifyPayment']);
        Route::post('/failed', [PaymentController::class, 'paymentFailed']);
    });
});
```

---

### 3.2 Flutter Setup

#### Install Razorpay Flutter Plugin
**File**: `pubspec.yaml`
```yaml
dependencies:
  razorpay_flutter: ^1.3.7
```

Run:
```bash
flutter pub get
```

#### Create Payment Service
**File**: `lib/features/payment/services/payment_service.dart`
```dart
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../core/services/api_service.dart';

class PaymentService {
  late Razorpay _razorpay;
  Function(Map<String, dynamic>)? onSuccess;
  Function(Map<String, dynamic>)? onFailure;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Initialize payment
  void openCheckout({
    required String razorpayKey,
    required String razorpayOrderId,
    required double amount,
    required String orderNumber,
    required String userName,
    required String userEmail,
    required String userPhone,
    required Function(Map<String, dynamic>) onPaymentSuccess,
    required Function(Map<String, dynamic>) onPaymentFailure,
  }) {
    this.onSuccess = onPaymentSuccess;
    this.onFailure = onPaymentFailure;

    var options = {
      'key': razorpayKey,
      'order_id': razorpayOrderId,
      'amount': (amount * 100).toInt(), // Amount in paise
      'currency': 'INR',
      'name': 'Gaon Wali Chai',
      'description': 'Order #$orderNumber',
      'prefill': {
        'contact': userPhone,
        'email': userEmail,
        'name': userName,
      },
      'theme': {
        'color': '#8B4513', // Your app primary color
      },
      'modal': {
        'ondismiss': () {
          onFailure({'error': 'Payment cancelled by user'});
        }
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      onFailure({'error': e.toString()});
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (onSuccess != null) {
      onSuccess!({
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (onFailure != null) {
      onFailure!({
        'error_code': response.code,
        'error_description': response.message,
      });
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}
```

#### Create Payment API Service
**File**: `lib/features/payment/data/services/payment_api_service.dart`
```dart
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

class PaymentApiService {
  final ApiService _api = ApiService();

  /// Verify payment with backend
  Future<ApiResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required int orderId,
  }) async {
    return await _api.post(
      '${ApiConfig.baseUrl}/payment/verify',
      {
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
        'order_id': orderId,
      },
      requiresAuth: true,
    );
  }

  /// Report payment failure
  Future<ApiResponse> reportPaymentFailure({
    required int orderId,
    String? errorCode,
    String? errorDescription,
  }) async {
    return await _api.post(
      '${ApiConfig.baseUrl}/payment/failed',
      {
        'order_id': orderId,
        'error_code': errorCode,
        'error_description': errorDescription,
      },
      requiresAuth: true,
    );
  }
}
```

---

## 📦 Phase 4: Order Management

### 4.1 Order Success Screen
**File**: `lib/features/orders/presentation/screens/order_success_screen.dart`

**Features:**
- Success animation (Lottie or custom)
- Order number display
- Estimated delivery time
- "Track Order" button
- "Back to Home" button
- "View Order Details" button

**UI:**
```dart
✅ Success Icon (animated)

Order Placed Successfully!

Order Number: #ORD-123456
Payment: Completed
Estimated Delivery: 30-40 mins

[Track Order]
[View Order Details]
[Back to Home]
```

---

### 4.2 Order Failure Screen
**File**: `lib/features/orders/presentation/screens/order_failure_screen.dart`

**Features:**
- Failure icon
- Error message
- "Retry Payment" button
- "Change Payment Method" button
- "Back to Cart" button

---

### 4.3 Orders List Screen (Update Existing)
**File**: `lib/features/orders/presentation/screens/orders_screen.dart`

**Features:**
- List of all orders
- Order status badge
- Order date & time
- Total amount
- Tap to view details
- Pull to refresh
- Filter by status (tabs)

**Tabs:**
- All
- Pending
- Confirmed
- Delivered
- Cancelled

---

### 4.4 Order Details Screen
**File**: `lib/features/orders/presentation/screens/order_detail_screen.dart`

**Sections:**
- Order status timeline
- Order items list
- Delivery address
- Payment details
- Price breakdown
- Order number & date
- "Reorder" button (for delivered orders)
- "Cancel Order" button (for pending)

---

## ✅ Implementation Checklist

### Phase 1: Address Management (Week 1)
- [ ] Create AddressModel (already exists, verify)
- [ ] Create AddressRepository (already exists, verify)
- [ ] Create AddressCard widget
- [ ] Create AddressesScreen (list)
- [ ] Create AddEditAddressScreen (form)
- [ ] Add navigation from profile
- [ ] Test CRUD operations

### Phase 2: Checkout Flow (Week 2)
- [ ] Create CheckoutScreen
- [ ] Add cart summary section
- [ ] Add address selection section
- [ ] Create AddressSelectionSheet widget
- [ ] Add payment method selection
- [ ] Add order summary section
- [ ] Implement "Place Order" logic
- [ ] Handle loading & errors
- [ ] Test end-to-end flow

### Phase 3: Razorpay Integration (Week 2-3)

#### Backend
- [ ] Install Razorpay PHP SDK
- [ ] Create razorpay config
- [ ] Add environment variables
- [ ] Create PaymentService
- [ ] Update OrderController
- [ ] Add migration for Razorpay fields
- [ ] Create PaymentController
- [ ] Add payment routes
- [ ] Test Razorpay order creation
- [ ] Test payment verification

#### Flutter
- [ ] Add razorpay_flutter dependency
- [ ] Create PaymentService
- [ ] Create PaymentApiService
- [ ] Integrate payment in CheckoutScreen
- [ ] Handle payment success
- [ ] Handle payment failure
- [ ] Test with Razorpay test mode
- [ ] Add error handling

### Phase 4: Order Management (Week 3-4)
- [ ] Create OrderSuccessScreen
- [ ] Create OrderFailureScreen
- [ ] Update OrdersScreen with real data
- [ ] Create OrderDetailScreen
- [ ] Add order status timeline widget
- [ ] Add order filtering
- [ ] Add pull to refresh
- [ ] Add "Reorder" functionality
- [ ] Add "Cancel Order" functionality
- [ ] Test complete flow

### Testing & Polish (Week 4)
- [ ] Test complete checkout flow
- [ ] Test all payment methods
- [ ] Test edge cases (no address, empty cart, etc.)
- [ ] Test error scenarios
- [ ] Add loading states
- [ ] Add proper error messages
- [ ] Polish UI/UX
- [ ] Add analytics events
- [ ] Add crashlytics

---

## 🔐 Security Considerations

### Backend
- ✅ Never expose Razorpay key_secret to frontend
- ✅ Always verify payment signature on backend
- ✅ Use webhook for payment confirmation (optional)
- ✅ Validate user owns the order
- ✅ Validate user owns the address
- ✅ Use HTTPS only
- ✅ Rate limit payment endpoints

### Flutter
- ✅ Store Razorpay key_id securely (can be public)
- ✅ Never store payment details
- ✅ Always verify payment on backend
- ✅ Handle payment failures gracefully
- ✅ Clear sensitive data after payment

---

## 🎨 UI/UX Guidelines

### Colors (Matcha Green Theme)
- Primary: #8B4513 (Brown)
- Success: #88B04B (Matcha Green)
- Error: #F44336 (Red)
- Background: #FFF8F0 (Cream)

### Fonts
- Use existing AppTypography
- Keep consistent with app theme

### Animations
- Smooth transitions
- Loading indicators
- Success animations
- Error shake animations

---

## 📝 API Endpoints Summary

### Already Implemented
```
POST   /api/orders              - Create order
GET    /api/orders              - Get user orders
GET    /api/orders/{id}         - Get order details
GET    /api/addresses           - Get addresses
POST   /api/addresses           - Create address
PUT    /api/addresses/{id}      - Update address
DELETE /api/addresses/{id}      - Delete address
```

### To Be Added
```
POST   /api/payment/verify      - Verify Razorpay payment
POST   /api/payment/failed      - Report payment failure
POST   /api/orders/{id}/cancel  - Cancel order (optional)
POST   /api/orders/reorder      - Reorder (optional)
```

---

## 🚀 Timeline Estimate

- **Week 1**: Address Management (3-4 days)
- **Week 2**: Checkout Flow (4-5 days)
- **Week 3**: Razorpay Integration (5-6 days)
- **Week 4**: Order Management & Testing (4-5 days)

**Total**: 3-4 weeks for complete implementation

---

## 💡 Pro Tips

1. **Start with Test Mode**: Use Razorpay test keys initially
2. **Test Cards**: Razorpay provides test cards for testing
3. **Webhooks**: Set up webhooks for production for reliability
4. **Error Handling**: Handle all edge cases gracefully
5. **User Feedback**: Clear messages for every action
6. **Loading States**: Always show loading during API calls
7. **Offline Support**: Handle network errors properly
8. **Analytics**: Track checkout funnel metrics
9. **COD Option**: Consider adding Cash on Delivery as fallback
10. **Phone Pay/GPay**: Razorpay handles UPI apps automatically

---

## 📚 Resources

### Razorpay Documentation
- [Razorpay Flutter SDK](https://razorpay.com/docs/payments/payment-gateway/flutter/integration/)
- [Razorpay PHP SDK](https://razorpay.com/docs/payments/server-integration/php/)
- [Payment Links](https://razorpay.com/docs/payment-links/)
- [Webhooks](https://razorpay.com/docs/webhooks/)

### Test Credentials
```
Test Cards: 4111 1111 1111 1111
CVV: Any 3 digits
Expiry: Any future date

UPI: success@razorpay
```

---

## 🎯 Success Metrics

After implementation, track:
- ✅ Checkout completion rate
- ✅ Payment success rate
- ✅ Average order value
- ✅ Time to complete checkout
- ✅ User drop-off points
- ✅ Payment method preferences

---

## 🔄 Future Enhancements

- [ ] Wallet integration (Paytm, PhonePe)
- [ ] Offers & coupon codes
- [ ] Split payments
- [ ] Recurring payments (subscriptions)
- [ ] International payments (Stripe)
- [ ] EMI options
- [ ] Save card for future (tokenization)
- [ ] Order tracking with live updates
- [ ] Push notifications for order status

---

## ✨ Conclusion

This plan provides a complete roadmap for implementing a production-ready checkout and payment system for Gaon Wali Chai using Razorpay. Follow the phases sequentially for best results.

**Next Step**: Start with Phase 1 (Address Management) and test thoroughly before moving to the next phase.

---

**Created**: December 27, 2025
**Status**: Ready for Implementation
**Estimated Timeline**: 3-4 weeks
