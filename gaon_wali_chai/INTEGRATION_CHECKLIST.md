# 📋 Integration Checklist for Frontend Developer

Use this checklist to integrate the Gaon Wali Chai API with your Flutter frontend.

## ✅ Backend Setup (Already Complete)

- [x] Laravel API created
- [x] All authentication endpoints implemented
- [x] Database migrations run
- [x] Server running on `http://localhost:8000`
- [x] All routes registered and tested
- [x] Documentation created

---

## 📱 Frontend Integration Steps

### Phase 1: Setup & Configuration (30 minutes)

- [ ] **Update API Base URL**
  - Location: Create `lib/core/constants/api_constants.dart`
  - For Android Emulator: `http://10.0.2.2:8000/api`
  - For iOS Simulator: `http://localhost:8000/api`
  - For Physical Device: `http://YOUR_COMPUTER_IP:8000/api`
  - See: `FLUTTER_INTEGRATION.md` for complete code

- [ ] **Install Required Packages**
  ```yaml
  dependencies:
    http: ^1.1.0
    flutter_secure_storage: ^9.0.0
    provider: ^6.1.1  # or riverpod: ^2.4.9
  ```

- [ ] **Create Folder Structure**
  ```
  lib/
  ├── core/
  │   └── constants/
  │       └── api_constants.dart
  ├── features/
  │   └── auth/
  │       ├── data/
  │       │   ├── models/
  │       │   │   └── user_model.dart
  │       │   └── datasources/
  │       │       ├── auth_remote_datasource.dart
  │       │       └── auth_local_datasource.dart
  │       └── presentation/
  │           ├── screens/
  │           └── providers/
  ```

### Phase 2: Core Implementation (2-3 hours)

- [ ] **Create API Constants**
  - Copy from `FLUTTER_INTEGRATION.md` → API Constants section
  - Update base URL for your environment

- [ ] **Create User Model**
  - Copy from `FLUTTER_INTEGRATION.md` → User Model section
  - File: `lib/features/auth/data/models/user_model.dart`

- [ ] **Create Remote Data Source**
  - Copy from `FLUTTER_INTEGRATION.md` → API Service Class section
  - File: `lib/features/auth/data/datasources/auth_remote_datasource.dart`
  - Implements all API calls

- [ ] **Create Local Data Source**
  - Copy from `FLUTTER_INTEGRATION.md` → Token Storage section
  - File: `lib/features/auth/data/datasources/auth_local_datasource.dart`
  - Handles token persistence

- [ ] **Create State Management**
  - Copy from `FLUTTER_INTEGRATION.md` → Provider/State Management section
  - File: `lib/features/auth/presentation/providers/auth_provider.dart`
  - Choose Provider or Riverpod

### Phase 3: Connect Screens (3-4 hours)

#### Sign Up Screen Integration
- [ ] Import auth provider
- [ ] Connect name input field
- [ ] Connect phone input field
- [ ] Connect password input field
- [ ] Call `register()` on button press
- [ ] Show loading indicator
- [ ] Handle success → Navigate to OTP screen
- [ ] Handle error → Show error message

**Test**: Register a new user → Should navigate to OTP screen

#### OTP Verification Screen Integration
- [ ] Receive phone number from previous screen
- [ ] Create 6-digit OTP input field
- [ ] Call `verifyOtp()` on submit
- [ ] Show loading indicator
- [ ] Handle success → Save token → Navigate to Home
- [ ] Handle error → Show error message
- [ ] Implement "Resend OTP" button
- [ ] Add countdown timer (show resend after 60 seconds)

**Test**: Enter OTP from logs → Should login and navigate to home

#### Sign In Screen Integration
- [ ] Connect phone input field
- [ ] Connect password input field
- [ ] Call `login()` on button press
- [ ] Show loading indicator
- [ ] Handle success → Save token → Navigate to Home
- [ ] Handle unverified → Navigate to OTP screen
- [ ] Handle error → Show error message
- [ ] Implement "Forgot Password" link

**Test**: Login with registered user → Should navigate to home

#### Forgot Password Screen Integration
- [ ] Connect phone input field
- [ ] Call `forgotPassword()` on submit
- [ ] Show loading indicator
- [ ] Handle success → Navigate to Reset Password screen
- [ ] Handle error → Show error message

**Test**: Request password reset → Should navigate to reset screen

#### Reset Password Screen Integration
- [ ] Receive phone number from previous screen
- [ ] Create OTP input field
- [ ] Create password input field
- [ ] Create confirm password input field
- [ ] Call `resetPassword()` on submit
- [ ] Validate password match
- [ ] Show loading indicator
- [ ] Handle success → Navigate to Login screen
- [ ] Handle error → Show error message

**Test**: Reset password with OTP → Should update password

### Phase 4: Protected Features (1-2 hours)

#### Home/Dashboard Screen
- [ ] Get token from storage on app start
- [ ] Call `getUser()` to fetch user profile
- [ ] Display user information
- [ ] Handle token expiry → Logout and navigate to login

#### Profile Screen
- [ ] Display user data
- [ ] Allow editing name, email, profile image
- [ ] Call `updateProfile()` on save
- [ ] Update local user data

#### Logout Functionality
- [ ] Implement logout button
- [ ] Call `logout()` on press
- [ ] Clear token from storage
- [ ] Navigate to welcome/login screen

### Phase 5: Polish & Testing (2-3 hours)

- [ ] **Error Handling**
  - [ ] Network errors
  - [ ] Validation errors
  - [ ] Server errors
  - [ ] Display user-friendly messages

- [ ] **Loading States**
  - [ ] Show spinners during API calls
  - [ ] Disable buttons while loading
  - [ ] Add shimmer effects if needed

- [ ] **Input Validation**
  - [ ] Phone number format
  - [ ] Password strength
  - [ ] Required fields
  - [ ] OTP format (6 digits)

- [ ] **User Feedback**
  - [ ] Success messages
  - [ ] Error messages
  - [ ] Toast notifications or SnackBars

- [ ] **Session Management**
  - [ ] Auto-login if token exists
  - [ ] Handle token expiry
  - [ ] Refresh token if needed

---

## 🧪 Testing Checklist

### Registration Flow
- [ ] Can register with valid data
- [ ] Shows validation errors for invalid data
- [ ] Receives OTP (check Laravel logs)
- [ ] Can verify OTP
- [ ] Redirects to home after verification
- [ ] Token is stored securely

### Login Flow
- [ ] Can login with verified account
- [ ] Shows error for wrong credentials
- [ ] Shows "verify phone" for unverified account
- [ ] Redirects to home after login
- [ ] Token is stored securely

### Forgot Password Flow
- [ ] Can request password reset
- [ ] Receives OTP (check Laravel logs)
- [ ] Can reset password with valid OTP
- [ ] Shows error for invalid OTP
- [ ] Can login with new password

### Social Login Flow (If Implemented)
- [ ] Can authenticate with Google
- [ ] Can authenticate with Facebook
- [ ] User data is correctly mapped
- [ ] Token is received and stored

### Protected Features
- [ ] Can access user profile
- [ ] Can update profile information
- [ ] Can logout successfully
- [ ] Token is cleared on logout
- [ ] Redirects to login when token expires

---

## 📚 Reference Documents

- **API Endpoints**: `API_DOCUMENTATION.md`
- **Flutter Integration Code**: `FLUTTER_INTEGRATION.md`
- **API Testing**: `TEST_API.md`
- **Setup Guide**: `SETUP_GUIDE.md`
- **Implementation Summary**: `IMPLEMENTATION_SUMMARY.md`

---

## 🐛 Common Issues & Solutions

### Issue: Can't connect to API
**Solution**: 
- Android Emulator: Use `10.0.2.2` instead of `localhost`
- Physical Device: Use your computer's IP address
- Check if Laravel server is running: `php artisan serve`

### Issue: OTP not working
**Solution**:
- Check Laravel logs: `storage/logs/laravel.log`
- OTP expires after 10 minutes
- Each OTP can only be used once

### Issue: Token not persisting
**Solution**:
- Use `flutter_secure_storage` package
- Check if token is being saved after login/registration
- Verify token is being loaded on app start

### Issue: 401 Unauthorized error
**Solution**:
- Check if token is included in Authorization header
- Format: `Authorization: Bearer {token}`
- Token may have expired → Need to login again

### Issue: CORS errors (Web)
**Solution**:
- Update `config/cors.php` in Laravel
- Add your frontend URL to allowed origins

---

## 📞 Need Help?

1. Check the documentation files listed above
2. Review the Flutter integration examples
3. Test endpoints using Postman collection
4. Check Laravel logs for errors
5. Verify all packages are installed

---

## ✨ Tips for Smooth Integration

1. **Start Small**: Implement one flow at a time (registration first)
2. **Test Frequently**: Test each screen as you build it
3. **Use Postman**: Test API endpoints before implementing in Flutter
4. **Check Logs**: Always check Laravel logs when debugging OTP issues
5. **Error Handling**: Implement proper error handling from the start
6. **Token Management**: Store tokens securely and handle expiry
7. **User Feedback**: Show loading states and error messages

---

## 🎯 Current Status

- ✅ Backend: 100% Complete
- ⬜ Frontend: Ready to integrate
- ⬜ Testing: Pending
- ⬜ Production: SMS integration needed

---

## 📅 Estimated Timeline

- **Phase 1 - Setup**: 30 minutes
- **Phase 2 - Core Implementation**: 2-3 hours
- **Phase 3 - Screen Integration**: 3-4 hours
- **Phase 4 - Protected Features**: 1-2 hours
- **Phase 5 - Polish & Testing**: 2-3 hours

**Total**: 9-13 hours for complete integration

---

Good luck with the integration! 🚀

The backend is solid and ready. Follow this checklist step by step, and you'll have a fully functional authentication system in no time!
