# 🚀 Quick Start Guide - Testing Flutter Backend Integration

## Prerequisites Checklist

- [ ] Flutter SDK installed
- [ ] Android Studio / VS Code with Flutter extension
- [ ] Android Emulator or iOS Simulator running
- [ ] Laravel backend running at `http://localhost:8000`
- [ ] Database seeded with sample data

---

## Step 1: Start the Backend

```bash
# Open terminal in gaon_wali_chai_api folder
cd c:\Projects\gaon_wali_chai_api

# Start Laravel server
php artisan serve

# You should see:
# Starting Laravel development server: http://127.0.0.1:8000
```

**Keep this terminal running!**

---

## Step 2: Verify Backend is Working

Open browser and test these URLs:

1. **Categories:** http://localhost:8000/api/categories
   - Should return JSON with categories (Tea, Snacks, etc.)

2. **Products:** http://localhost:8000/api/products
   - Should return JSON with products and their details

If you see JSON data, backend is ready! ✅

---

## Step 3: Configure Flutter App

### For Android Emulator (Default):
No changes needed! Already configured to use `http://10.0.2.2:8000/api`

### For iOS Simulator:
Edit `lib/core/config/api_config.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

### For Physical Device:
1. Find your computer's IP address:
   - Windows: `ipconfig` (look for IPv4)
   - Mac/Linux: `ifconfig` (look for inet)
   
2. Edit `lib/core/config/api_config.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:8000/api'; // e.g., http://192.168.1.100:8000/api
```

---

## Step 4: Run the Flutter App

```bash
# Open terminal in gaon_wali_chai folder
cd c:\Projects\gaon_wali_chai

# Run the app
flutter run
```

**Wait for app to build and launch on emulator/simulator**

---

## Step 5: Test the Integration

### Test 1: Menu Screen ✅

1. **App should launch and show Menu screen**
   - ✅ Loading spinner appears briefly
   - ✅ Categories load (Tea, Snacks, Cold Beverages, Desserts)
   - ✅ Products display with images and prices
   - ✅ Real data from backend (not hardcoded)

2. **Test Category Filtering**
   - ✅ Tap "Tea" category
   - ✅ Only tea products show
   - ✅ Tap "Snacks" category
   - ✅ Only snack products show

3. **Test Refresh**
   - ✅ Pull down to refresh
   - ✅ Loading indicator shows
   - ✅ Data reloads

---

### Test 2: Product Details & Add to Cart ✅

1. **Open Product Details**
   - ✅ Tap any product card
   - ✅ Product detail screen opens
   - ✅ Shows product image, name, description
   - ✅ Shows available sizes (if any)
   - ✅ Shows available variants (if any)

2. **Select Options**
   - ✅ Select a size (e.g., "Medium", "Large")
   - ✅ Price updates based on size
   - ✅ Select variants (e.g., "Extra Sugar", "Less Milk")
   - ✅ Price updates with variant prices
   - ✅ Adjust quantity with +/- buttons
   - ✅ Total price calculates correctly

3. **Add to Cart**
   - ✅ Tap "Add to Cart" button
   - ✅ Button shows loading spinner
   - ✅ Success message appears: "[Product] added to cart"
   - ✅ Screen closes and returns to menu

---

### Test 3: Cart Screen ✅

1. **View Cart**
   - ✅ Navigate to Cart tab/screen
   - ✅ Shows all added items
   - ✅ Each item displays:
     - Product name and image
     - Selected size (e.g., "Size: Large")
     - Selected variants (e.g., "Variants: Extra Sugar")
     - Quantity
     - Individual item total

2. **Update Quantity**
   - ✅ Tap + button to increase quantity
   - ✅ Item quantity increases
   - ✅ Item total updates
   - ✅ Subtotal updates
   - ✅ Grand total updates
   - ✅ Tap - button to decrease quantity
   - ✅ All prices update correctly

3. **Remove Item**
   - ✅ Tap delete/trash icon on any item
   - ✅ Item removed from cart
   - ✅ Success message: "Item removed from cart"
   - ✅ Cart refreshes

4. **Check Price Breakdown**
   - ✅ Subtotal shows sum of all items
   - ✅ Delivery fee shows (₹50)
   - ✅ Total = Subtotal + Delivery fee

5. **Empty Cart**
   - ✅ Remove all items
   - ✅ Empty state shows
   - ✅ Message: "Your cart is empty"
   - ✅ "Browse Menu" button appears

---

## Troubleshooting

### Problem: "Failed to connect" or "Network Error"

**Solutions:**
1. Verify backend is running (`php artisan serve`)
2. Check API base URL in `lib/core/config/api_config.dart`
3. For Android emulator, ensure using `10.0.2.2` not `localhost`
4. For physical device, ensure phone and computer on same WiFi
5. Check firewall is not blocking port 8000

**Test backend manually:**
```bash
# In browser or Postman
http://localhost:8000/api/categories
http://localhost:8000/api/products
```

---

### Problem: Menu shows empty or loading forever

**Solutions:**
1. Check backend database has seeded data:
   ```bash
   php artisan migrate:fresh --seed
   ```
2. Check Laravel logs:
   ```bash
   tail -f storage/logs/laravel.log
   ```
3. Enable Flutter debug logging:
   ```bash
   flutter run --verbose
   ```

---

### Problem: Cart operations fail

**Possible Causes:**
- Not authenticated (cart requires auth)
- Token expired or invalid
- Backend auth middleware blocking requests

**Solution:**
Make sure user is logged in and token is saved. For testing, you can temporarily make cart endpoints public in `routes/api.php`:

```php
// Temporary for testing (remove in production)
Route::get('cart', [CartController::class, 'index']);
Route::post('cart', [CartController::class, 'add']);
Route::put('cart/{id}', [CartController::class, 'update']);
Route::delete('cart/{id}', [CartController::class, 'remove']);
```

---

### Problem: Images not loading

**Solutions:**
1. Check internet connection
2. Verify image URLs in database are valid
3. Check Android manifest has internet permission:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

---

## Expected Console Output (Success)

When everything works, you should see in Flutter console:

```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain - develop for Android devices
✓ Chrome - develop for the web
✓ Android Studio (version 20xx.x)
✓ VS Code (version x.xx)
✓ Connected device (1 available)

Running "flutter pub get" in gaon_wali_chai...
Launching lib/main.dart on sdk gphone64 x86 64 in debug mode...
✓ Built build/app/outputs/flutter-apk/app-debug.apk.
Installing build/app/outputs/flutter-apk/app-debug.apk...
Debug service listening on ws://127.0.0.1:xxxxx
```

No red errors should appear!

---

## Verification Checklist

Use this checklist to confirm integration is working:

### Backend
- [ ] Laravel server running on port 8000
- [ ] Database migrated and seeded
- [ ] Can access http://localhost:8000/api/categories in browser
- [ ] Can access http://localhost:8000/api/products in browser

### Flutter App
- [ ] App builds without errors
- [ ] App launches successfully
- [ ] No red errors in console

### Menu Screen
- [ ] Loading spinner shows initially
- [ ] Categories load from backend
- [ ] Products load with images
- [ ] Category filtering works
- [ ] Pull-to-refresh works

### Product Details
- [ ] Product details display correctly
- [ ] Can select size
- [ ] Can select variants
- [ ] Price calculates correctly
- [ ] Add to cart works
- [ ] Loading indicator shows
- [ ] Success message appears

### Cart Screen
- [ ] Cart loads from backend
- [ ] Items display correctly
- [ ] Can increase quantity
- [ ] Can decrease quantity
- [ ] Can remove items
- [ ] Prices update correctly
- [ ] Empty state works

---

## Success Criteria ✅

If you can complete these tasks without errors, integration is successful:

1. ✅ Launch app
2. ✅ See real products from backend
3. ✅ Tap a product
4. ✅ Select size and variants
5. ✅ Add to cart
6. ✅ See success message
7. ✅ Navigate to cart
8. ✅ See added item with correct details
9. ✅ Change quantity
10. ✅ See updated prices

**If all 10 steps work → Integration is COMPLETE! 🎉**

---

## Next Steps After Testing

Once testing is successful:

1. **Implement remaining features:**
   - Order placement (checkout)
   - Order history
   - Address management

2. **Add authentication:**
   - Integrate login/register screens
   - Token management
   - Protected routes

3. **Polish UI:**
   - Better error messages
   - Loading animations
   - Image placeholders
   - Toast notifications

4. **Prepare for production:**
   - Update API base URL to production
   - Enable ProGuard (Android)
   - Configure release builds
   - Test on physical devices

---

## Support

If you encounter issues:

1. Check this guide's troubleshooting section
2. Review full documentation in `FLUTTER_BACKEND_INTEGRATION_COMPLETE.md`
3. Check API documentation in `API_DOCUMENTATION_COMPLETE.md`
4. Enable verbose logging: `flutter run --verbose`

---

**Good luck with testing! 🚀**
