# Google OAuth Setup Guide

## Steps to Enable Google Sign-In

### 1. Backend Setup (Laravel)

Run the migration to add the `provider` column:
```bash
cd c:\Projects\gaon_wali_chai_api
php artisan migrate
```

### 2. Google Cloud Console Setup

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com/

2. **Create a New Project** (or select existing)
   - Click "Select a project" → "New Project"
   - Name: "Gaonwali Chai"
   - Click "Create"

3. **Enable Google Sign-In API**
   - Go to "APIs & Services" → "Library"
   - Search for "Google Sign-In API"
   - Click "Enable"

4. **Create OAuth 2.0 Credentials**
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth 2.0 Client ID"
   
   **For Android:**
   - Application type: "Android"
   - Name: "Gaonwali Chai Android"
   - Package name: `com.example.gaon_wali_chai` (check your AndroidManifest.xml)
   - Get SHA-1 fingerprint:
     ```bash
     cd c:\Projects\gaon_wali_chai\android
     gradlew signingReport
     ```
   - Copy the SHA-1 from the debug variant
   - Paste it in "SHA-1 certificate fingerprint"
   - Click "Create"

   **For Web (optional):**
   - Application type: "Web application"
   - Name: "Gaonwali Chai Web"
   - Authorized JavaScript origins: `http://localhost`
   - Authorized redirect URIs: `http://localhost/auth/callback`
   - Click "Create"

5. **Download Client ID**
   - You'll get a client ID like: `xxxxx-xxxxx.apps.googleusercontent.com`
   - Save this for later

### 3. Flutter Configuration

#### Android Setup

1. **Update `android/app/build.gradle`:**
   ```gradle
   android {
       defaultConfig {
           minSdkVersion 21  // Google Sign-In requires min 21
       }
   }
   ```

2. **No additional configuration needed** - The package handles everything automatically!

#### iOS Setup (if needed)

1. **Update `ios/Runner/Info.plist`:**
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleTypeRole</key>
           <string>Editor</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
           </array>
       </dict>
   </array>
   ```

2. **Update `ios/Runner/Info.plist` for client ID:**
   ```xml
   <key>GIDClientID</key>
   <string>YOUR-CLIENT-ID.apps.googleusercontent.com</string>
   ```

### 4. Install Flutter Dependencies

```bash
cd c:\Projects\gaon_wali_chai
flutter pub get
```

### 5. Test the Integration

1. **Start the Laravel backend:**
   ```bash
   cd c:\Projects\gaon_wali_chai_api
   php artisan serve
   ```

2. **Run the Flutter app:**
   ```bash
   cd c:\Projects\gaon_wali_chai
   flutter run
   ```

3. **Test Google Sign-In:**
   - Open the app
   - Go to Sign In screen
   - Click the Google button
   - Select your Google account
   - You should be logged in and redirected to home screen

## How It Works

### Flow:
1. User clicks Google Sign-In button
2. Flutter opens Google sign-in sheet
3. User selects Google account and grants permissions
4. Flutter receives user data (id, name, email, photo)
5. Flutter sends this data to Laravel backend `/api/auth/social-login`
6. Laravel checks if user exists by `provider_id` or `email`
7. If new user, creates account (auto-verified)
8. If existing user, logs them in
9. Laravel returns authentication token
10. Flutter stores token and navigates to home screen

### Backend API

**Endpoint:** `POST /api/auth/social-login`

**Request Body:**
```json
{
  "provider": "google",
  "provider_id": "12345678901234567890",
  "name": "John Doe",
  "email": "john@example.com",
  "profile_image": "https://..."
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "1|abc123...",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": null,
      "profile_image": "https://...",
      "is_verified": true,
      "auth_provider": "google"
    }
  }
}
```

## Troubleshooting

### "Sign in failed" error
- Check if you enabled Google Sign-In API in Google Cloud Console
- Verify SHA-1 fingerprint matches
- Make sure package name in Google Console matches your app

### "Network error"
- Ensure Laravel backend is running on `http://10.0.2.2:8000`
- Check if social-login endpoint is accessible

### "Developer error" on Google sign-in
- SHA-1 fingerprint doesn't match
- Package name doesn't match
- OAuth client not properly configured

## Security Notes

- User passwords are NOT stored for social login users
- Users are automatically verified when signing in with Google
- Provider ID is unique per user per provider
- Tokens are securely stored using flutter_secure_storage

## Next Steps

- Add Facebook login (similar process)
- Add Apple Sign-In for iOS
- Implement phone number linking for social users
- Add profile completion flow for social users
