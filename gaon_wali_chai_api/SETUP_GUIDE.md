# Quick Setup Guide - Gaon Wali Chai API

Follow these steps to get the API up and running quickly.

## Step 1: Database Configuration

1. Create a MySQL database:
```sql
CREATE DATABASE gaon_wali_chai;
```

2. Update your `.env` file:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=gaon_wali_chai
DB_USERNAME=root
DB_PASSWORD=your_password
```

## Step 2: Run Migrations

The migrations have already been run. If you need to reset:
```bash
php artisan migrate:fresh
```

## Step 3: Start the Server

```bash
php artisan serve
```

The API will be available at: `http://localhost:8000`

## Step 4: Test the API

### Option 1: Using Postman
1. Import the `Gaon_Wali_Chai_API.postman_collection.json` file into Postman
2. The collection includes all endpoints with example requests
3. Update the `token` variable after login/registration

### Option 2: Using cURL

**Register a user:**
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "name": "Test User",
    "phone": "1234567890",
    "password": "password123"
  }'
```

**Check the OTP in logs:**
```bash
tail -f storage/logs/laravel.log
```

**Verify OTP:**
```bash
curl -X POST http://localhost:8000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "phone": "1234567890",
    "otp": "YOUR_OTP_FROM_LOGS"
  }'
```

**Save the token from the response!**

**Login:**
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "phone": "1234567890",
    "password": "password123"
  }'
```

**Get User Profile (use token from login):**
```bash
curl -X GET http://localhost:8000/api/auth/user \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Step 5: Testing the Full Flow

### Registration Flow:
1. POST `/api/auth/register` - Register user
2. Check logs for OTP
3. POST `/api/auth/verify-otp` - Verify phone with OTP
4. Save the returned token

### Login Flow:
1. POST `/api/auth/login` - Login with phone & password
2. Save the returned token
3. GET `/api/auth/user` - Get user profile (with token)

### Forgot Password Flow:
1. POST `/api/auth/forgot-password` - Request password reset
2. Check logs for OTP
3. POST `/api/auth/reset-password` - Reset password with OTP
4. POST `/api/auth/login` - Login with new password

## Common Issues

### Issue: "Base table or view not found"
**Solution:** Run migrations
```bash
php artisan migrate
```

### Issue: "No application encryption key has been specified"
**Solution:** Generate app key
```bash
php artisan key:generate
```

### Issue: "Access denied for user"
**Solution:** Check your database credentials in `.env`

### Issue: "Can't see OTP"
**Solution:** Check Laravel logs
```bash
# Windows
type storage\logs\laravel.log

# Linux/Mac
tail -f storage/logs/laravel.log
```

## Integration with Frontend

### Base URL
```
http://localhost:8000/api
```

### Authentication Header
After login/registration, use the token in all protected endpoints:
```
Authorization: Bearer {token}
```

### Example Flutter/Dart Code

```dart
// Login Request
final response = await http.post(
  Uri.parse('http://localhost:8000/api/auth/login'),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  body: jsonEncode({
    'phone': '1234567890',
    'password': 'password123',
  }),
);

final data = jsonDecode(response.body);
final token = data['data']['token'];

// Protected Request (Get User)
final userResponse = await http.get(
  Uri.parse('http://localhost:8000/api/auth/user'),
  headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  },
);
```

## SMS Integration (Production)

Currently, OTPs are logged for development. For production:

1. **Install Twilio SDK:**
```bash
composer require twilio/sdk
```

2. **Update `.env`:**
```env
TWILIO_SID=your_twilio_sid
TWILIO_TOKEN=your_twilio_token
TWILIO_FROM=your_twilio_phone_number
```

3. **Uncomment Twilio code** in `app/Services/OtpService.php` (line 72-86)

## Next Steps

1. ✅ API is ready for testing
2. ✅ All endpoints are functional
3. ⬜ Integrate SMS provider (Twilio/Firebase)
4. ⬜ Configure CORS for your Flutter app
5. ⬜ Add rate limiting for production
6. ⬜ Set up proper error logging
7. ⬜ Deploy to production server

## Support

- Check `API_DOCUMENTATION.md` for detailed endpoint documentation
- Review `AUTH_SYSTEM_PLAN.md` for the complete authentication flow
- Look at the code in `app/Http/Controllers/AuthController.php` for implementation details

---

🚀 Your API is ready! Start integrating with your Flutter frontend.
