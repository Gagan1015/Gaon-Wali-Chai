# Gaon Wali Chai - Authentication API

Laravel backend API for Gaon Wali Chai mobile application authentication system.

## Features

- 📱 **Phone-based Authentication** - Register and login with phone number
- 🔐 **OTP Verification** - Secure 6-digit OTP verification for registration and password reset
- 🌐 **Social Login** - Google and Facebook authentication support
- 🔑 **JWT Tokens** - Laravel Sanctum for secure API token authentication
- 🔄 **Password Reset** - Forgot password flow with OTP verification
- 👤 **User Profile** - Get and update user profile information

## Tech Stack

- **Framework:** Laravel 11
- **Authentication:** Laravel Sanctum
- **Database:** MySQL
- **PHP Version:** 8.2+

## API Endpoints

### Public Endpoints (No Authentication Required)

#### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "phone": "1234567890",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful. Please verify your phone number with the OTP sent.",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "phone": "1234567890",
      "is_verified": false
    },
    "otp_sent": true
  }
}
```

#### Verify OTP
```http
POST /api/auth/verify-otp
Content-Type: application/json

{
  "phone": "1234567890",
  "otp": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Phone number verified successfully",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "phone": "1234567890",
      "email": null,
      "profile_image": null,
      "is_verified": true,
      "auth_provider": "phone"
    },
    "token": "1|abc123...",
    "token_type": "Bearer"
  }
}
```

#### Resend OTP
```http
POST /api/auth/resend-otp
Content-Type: application/json

{
  "phone": "1234567890",
  "type": "registration"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "phone": "1234567890",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "phone": "1234567890",
      "email": null,
      "profile_image": null,
      "is_verified": true,
      "auth_provider": "phone"
    },
    "token": "1|abc123...",
    "token_type": "Bearer"
  }
}
```

#### Forgot Password
```http
POST /api/auth/forgot-password
Content-Type: application/json

{
  "phone": "1234567890"
}
```

#### Reset Password
```http
POST /api/auth/reset-password
Content-Type: application/json

{
  "phone": "1234567890",
  "otp": "123456",
  "password": "newpassword123",
  "password_confirmation": "newpassword123"
}
```

#### Social Login
```http
POST /api/auth/social-login
Content-Type: application/json

{
  "provider": "google",
  "provider_id": "google-user-id-123",
  "name": "John Doe",
  "email": "john@example.com",
  "profile_image": "https://example.com/image.jpg"
}
```

### Protected Endpoints (Authentication Required)

Add the token to your requests:
```
Authorization: Bearer {your_token_here}
```

#### Get User Profile
```http
GET /api/auth/user
Authorization: Bearer {token}
```

#### Update Profile
```http
PUT /api/auth/update-profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "John Updated",
  "email": "john@example.com",
  "profile_image": "https://example.com/new-image.jpg"
}
```

#### Logout
```http
POST /api/auth/logout
Authorization: Bearer {token}
```

## Installation

### Prerequisites
- PHP 8.2 or higher
- Composer
- MySQL
- Laravel 11

### Setup Instructions

1. **Clone the repository**
```bash
git clone <repository-url>
cd gaon_wali_chai_api
```

2. **Install dependencies**
```bash
composer install
```

3. **Configure environment**
```bash
cp .env.example .env
```

Edit `.env` file with your database credentials:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=gaon_wali_chai
DB_USERNAME=root
DB_PASSWORD=your_password
```

4. **Generate application key**
```bash
php artisan key:generate
```

5. **Run migrations**
```bash
php artisan migrate
```

6. **Start the server**
```bash
php artisan serve
```

The API will be available at `http://localhost:8000`

## Database Schema

### Users Table
- `id` - Primary key
- `name` - User's full name
- `phone` - Phone number (unique)
- `email` - Email address (nullable, unique)
- `password` - Hashed password
- `profile_image` - Profile image URL (nullable)
- `auth_provider` - Authentication provider (phone, google, facebook)
- `provider_id` - Social provider user ID (nullable)
- `is_verified` - Phone verification status
- `phone_verified_at` - Timestamp of phone verification
- `created_at` - Registration timestamp
- `updated_at` - Last update timestamp

### OTPs Table
- `id` - Primary key
- `phone` - Phone number
- `otp` - 6-digit OTP code
- `type` - OTP type (registration, forgot_password)
- `expires_at` - Expiration timestamp (10 minutes)
- `is_used` - Whether OTP has been used
- `created_at` - Creation timestamp

## SMS Integration

The API is ready for SMS integration. Currently, OTPs are logged to the Laravel log file for development.

### To integrate SMS provider:

#### Option 1: Twilio
```bash
composer require twilio/sdk
```

Update `.env`:
```env
TWILIO_SID=your_twilio_sid
TWILIO_TOKEN=your_twilio_token
TWILIO_FROM=your_twilio_phone_number
```

Uncomment the Twilio code in `app/Services/OtpService.php`

#### Option 2: Firebase Cloud Messaging
Configure Firebase credentials in `.env` and implement the sending logic in OtpService.

## Development

### Check OTP in logs (Development)
```bash
tail -f storage/logs/laravel.log
```

### Clear cache
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

### Run tests (when implemented)
```bash
php artisan test
```

## Security

- ✅ Passwords are hashed using bcrypt
- ✅ API tokens via Laravel Sanctum
- ✅ OTP expiration (10 minutes)
- ✅ OTP single-use enforcement
- ✅ Input validation on all endpoints
- ✅ CORS configuration
- ⚠️ Enable HTTPS in production
- ⚠️ Configure rate limiting for OTP endpoints

## CORS Configuration

For Flutter/mobile app integration, ensure CORS is properly configured. Update `config/cors.php` if needed:

```php
'paths' => ['api/*'],
'allowed_origins' => [env('CORS_ALLOWED_ORIGINS', '*')],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

## Error Responses

All API endpoints return consistent error responses:

```json
{
  "success": false,
  "message": "Error message here",
  "error": "Detailed error (only in development)"
}
```

## Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation errors, invalid OTP)
- `401` - Unauthorized (invalid credentials)
- `403` - Forbidden (unverified account)
- `404` - Not Found
- `500` - Server Error

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues or questions, please create an issue in the repository.

---

Made with ❤️ for Gaon Wali Chai
