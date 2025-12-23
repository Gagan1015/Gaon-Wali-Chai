# Gaon Wali Chai - Authentication System Plan

## UI Screens Overview

Based on the provided designs, the authentication flow includes:

### 1. **Splash Screen**
- **Design**: Gaonwali Chai logo with tagline "Har Cup Mein Sukoon"
- **Purpose**: App initialization and branding
- **Duration**: 2-3 seconds
- **Navigation**: Auto-navigate to Slide/Onboarding

### 2. **Slide/Onboarding Screen**
- **Design**: 
  - Beautiful chai pouring image
  - Text: "Find the best Chai for you"
  - "Get Started" button
  - Pagination dots (slide indicators)
- **Purpose**: Introduce app features
- **Navigation**: Navigate to Welcome Page

### 3. **Welcome Page**
- **Design**:
  - Hero image: Chai cup with splash
  - Tagline: "Welcome to"
  - Gaonwali Chai logo
  - Two action buttons:
    - "Register" (primary)
    - "Login" (secondary)
- **Purpose**: Entry point for authentication
- **Color Scheme**: Warm beige/cream background with brown buttons

### 4. **Sign In Screen**
- **Design Elements**:
  - Header: "Gaonwali Chai - Sign In"
  - Subtitle: "Hi, Welcome back, you've been missed"
  - Input Fields:
    - Phone number (with phone icon)
    - Password (with eye icon for visibility toggle)
  - "Forgot Password?" link
  - "Login" button (brown)
  - Social login options:
    - Google
    - Facebook
  - Footer: "Don't have an account? Signup"
  - "Connect With" social media prompt
  - Terms & privacy policy text

### 5. **Sign Up Screen**
- **Design Elements**:
  - Header: "Gaonwali Chai - Sign Up"
  - Subtitle: "Create an account here"
  - Input Fields:
    - Name (with user icon)
    - Phone number (with phone icon)
    - Password (with eye icon for visibility toggle)
  - "Forgot Password?" link
  - "Signup" button (brown)
  - Social signup options:
    - Google
    - Facebook
  - Footer: "Already have an account? Login here"
  - "Connect With" social media prompt
  - Terms & privacy policy agreement

### 6. **Forgot Password Screen**
- **Design Elements**:
  - Back button
  - Header: "Forgot Password"
  - Subtitle: "Please enter your password here"
  - Input Fields:
    - Password (with eye icon)
    - Confirm Password (with eye icon)
  - "Create New Password" button (brown)

### 7. **Verify Code Screen**
- **Design Elements**:
  - Back button
  - Header: "Verify Code"
  - Subtitle: "Please enter the code we just sent to your register mobile number"
  - OTP Input: 6 digit boxes
  - Resend code options:
    - "Didn't receive OTP?"
    - "Resend Code"
  - "Verify" button (brown)

---

## Authentication Flow

```
Splash Screen (2-3s)
    ↓
Onboarding/Slide Screen
    ↓
Welcome Page
    ├── Register → Sign Up Screen
    │                ↓
    │            Verify Code (OTP)
    │                ↓
    │            Home/Dashboard
    │
    └── Login → Sign In Screen
                    ↓
                Home/Dashboard
                    
Forgot Password Flow:
Sign In → Forgot Password → Verify Code → Reset Password → Sign In
```

---

## Features & Functionality

### Core Authentication Features
1. **Phone-based Authentication**
   - Primary login method using phone number
   - OTP verification for registration
   - Password-based login after registration

2. **Social Authentication**
   - Google Sign In
   - Facebook Sign In

3. **Password Management**
   - Secure password input with visibility toggle
   - Password strength validation
   - Forgot password with OTP verification
   - Password reset functionality

4. **Session Management**
   - Persistent login (Remember me)
   - Secure token storage
   - Auto-logout on token expiry

5. **Input Validation**
   - Phone number format validation
   - Password strength requirements
   - OTP verification

---

## Technical Implementation Plan

### Phase 1: Project Setup & Dependencies
**Packages Required:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  # or
  riverpod: ^2.4.9
  
  # Navigation
  go_router: ^13.0.0
  
  # Authentication
  firebase_auth: ^4.16.0
  firebase_core: ^2.24.2
  google_sign_in: ^6.2.1
  flutter_facebook_auth: ^6.0.4
  
  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # API Calls (if using custom backend)
  dio: ^5.4.0
  
  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  pinput: ^3.0.1  # For OTP input
  
  # Form Validation
  form_field_validator: ^1.1.0
  
  # Animations
  lottie: ^3.0.0
  animate_do: ^3.1.2
```

### Phase 2: Project Structure
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_assets.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── routes/
│   │   └── app_router.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── features/
│   └── auth/
│       ├── data/
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── datasources/
│       │       ├── auth_local_datasource.dart
│       │       └── auth_remote_datasource.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart
│       │   └── usecases/
│       │       ├── login_usecase.dart
│       │       ├── register_usecase.dart
│       │       └── verify_otp_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   └── auth_provider.dart
│           ├── screens/
│           │   ├── splash_screen.dart
│           │   ├── onboarding_screen.dart
│           │   ├── welcome_screen.dart
│           │   ├── sign_in_screen.dart
│           │   ├── sign_up_screen.dart
│           │   ├── forgot_password_screen.dart
│           │   └── verify_code_screen.dart
│           └── widgets/
│               ├── custom_text_field.dart
│               ├── custom_button.dart
│               ├── social_login_buttons.dart
│               └── otp_input_field.dart
└── shared/
    └── widgets/
        ├── loading_indicator.dart
        └── error_dialog.dart
```

### Phase 3: Design System Implementation

#### Color Palette (From UI)
```dart
// lib/core/constants/app_colors.dart
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF8B4513); // Brown
  static const Color secondary = Color(0xFFF5E6D3); // Cream/Beige
  
  // Background
  static const Color background = Color(0xFFF5E6D3);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF8B7355);
  static const Color textHint = Color(0xFFB0A090);
  
  // Buttons
  static const Color buttonPrimary = Color(0xFF6B3410);
  static const Color buttonSecondary = Color(0xFFFFFFFF);
  
  // Input Fields
  static const Color inputBorder = Color(0xFFD4C4B0);
  static const Color inputFill = Color(0xFFFFFFFF);
  
  // Others
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
}
```

#### Typography
```dart
// Based on UI designs
- Headers: Bold, Dark Brown
- Body: Regular, Medium Brown
- Hints: Light, Gray-Brown
```

### Phase 4: Screen Implementation Order

#### Week 1: Foundation
1. **Splash Screen**
   - Logo animation
   - Auto-navigation timer
   - First-time check (show onboarding or skip)

2. **Onboarding Screen**
   - Page view with slides
   - Pagination indicators
   - Skip option
   - Get Started button

3. **Welcome Screen**
   - Hero image
   - Register/Login buttons
   - Navigation setup

#### Week 2: Core Auth Screens
4. **Sign Up Screen**
   - Form with validation
   - Password visibility toggle
   - Phone number formatting
   - API integration
   - Navigate to OTP verification

5. **Verify Code Screen**
   - 6-digit OTP input
   - Auto-focus next field
   - Resend OTP functionality
   - Timer countdown
   - Verification API call

6. **Sign In Screen**
   - Phone/password form
   - Remember me option
   - Validation
   - API integration

#### Week 3: Additional Features
7. **Forgot Password Screen**
   - Password reset flow
   - OTP verification
   - New password input

8. **Social Authentication**
   - Google Sign In integration
   - Facebook Sign In integration
   - Account linking

#### Week 4: Polish & Testing
9. **State Management**
   - Auth state handling
   - Token management
   - Session persistence

10. **Error Handling**
    - Network errors
    - Validation errors
    - User feedback

---

## Key UI Components to Build

### 1. Custom Text Field
```dart
Features:
- Icon prefix support
- Password visibility toggle
- Validation display
- Custom styling matching design
- Focus states
```

### 2. Custom Button
```dart
Features:
- Primary (filled brown)
- Secondary (outlined)
- Loading state
- Disabled state
- Custom width/height
```

### 3. Social Login Button
```dart
Features:
- Google icon button
- Facebook icon button
- Circular design
- Ripple effect
```

### 4. OTP Input Field
```dart
Features:
- 6 separate boxes
- Auto-focus next
- Number input only
- Paste support
- Clear functionality
```

---

## Backend Requirements

### API Endpoints Needed
```
POST /api/auth/register
POST /api/auth/verify-otp
POST /api/auth/login
POST /api/auth/forgot-password
POST /api/auth/reset-password
POST /api/auth/resend-otp
POST /api/auth/social-login
GET  /api/auth/user
POST /api/auth/logout
```

### Data Models
```dart
User Model:
- id
- name
- phone
- email (optional)
- profileImage
- authProvider (phone/google/facebook)
- isVerified
- createdAt

Auth Response:
- token
- refreshToken
- user
- expiresIn
```

---

## Security Considerations

1. **Password Security**
   - Minimum 8 characters
   - Hash passwords (bcrypt on backend)
   - Never store plain text

2. **Token Management**
   - JWT tokens
   - Secure storage (flutter_secure_storage)
   - Token refresh mechanism
   - Auto-logout on expiry

3. **API Security**
   - HTTPS only
   - Rate limiting
   - Input sanitization
   - CORS configuration

4. **Phone Verification**
   - SMS OTP (use services like Twilio, Firebase)
   - OTP expiry (5-10 minutes)
   - Rate limiting on OTP requests

---

## Testing Strategy

### Unit Tests
- Validators
- Auth repository
- Use cases

### Widget Tests
- Individual screens
- Custom widgets
- Form validation

### Integration Tests
- Complete auth flow
- Navigation
- State management

---

## Timeline Estimate

- **Week 1**: Setup, UI Components, Splash/Onboarding/Welcome (15-20 hours)
- **Week 2**: Sign Up, Sign In, OTP Verification (20-25 hours)
- **Week 3**: Forgot Password, Social Auth, State Management (15-20 hours)
- **Week 4**: Testing, Bug Fixes, Polish (10-15 hours)

**Total**: 60-80 hours for complete authentication system

---

## Next Steps

1. ✅ Initialize Flutter project
2. ⬜ Set up Firebase project (if using Firebase)
3. ⬜ Add required dependencies to pubspec.yaml
4. ⬜ Create project folder structure
5. ⬜ Define color palette and theme
6. ⬜ Implement custom UI components
7. ⬜ Build screens in order
8. ⬜ Integrate backend APIs
9. ⬜ Add state management
10. ⬜ Testing and refinement

---

## Resources & Assets Needed

### Images
- [ ] Splash screen logo
- [ ] Onboarding chai pouring image
- [ ] Welcome page chai splash image
- [ ] Background textures/patterns

### Icons
- [ ] Phone icon
- [ ] Password/lock icon
- [ ] Eye icon (show/hide password)
- [ ] Google logo
- [ ] Facebook logo
- [ ] User/profile icon

### Fonts
- [ ] Primary font (appears to be a serif or custom font for headers)
- [ ] Secondary font for body text

---

## Notes
- The app has a warm, inviting aesthetic with chai/tea theme
- Consistent brown color scheme throughout
- Social login should be prominently featured
- Phone-based auth is the primary method
- OTP verification is crucial for security
- UI should feel premium but approachable
