import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/social_login_button.dart';
import '../../data/datasources/google_sign_in_service.dart';
import '../providers/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _googleSignInService = GoogleSignInService();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await authProvider.login(
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (result['success'] && mounted) {
        // Navigate to main screen with bottom navigation
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } else if (result.containsKey('needsVerification') &&
          result['needsVerification'] == true &&
          mounted) {
        // Navigate to OTP screen if phone not verified
        Navigator.pushNamed(
          context,
          '/verify-code',
          arguments: {'phone': _phoneController.text.trim()},
        );
      } else if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleGoogleSignIn() async {
    print('Google Sign-In button tapped');
    setState(() => _isGoogleLoading = true);

    try {
      final googleData = await _googleSignInService.signInWithGoogle();

      print('Google data received: $googleData');

      if (googleData == null && mounted) {
        // User cancelled or error occurred
        print('Google sign-in cancelled or failed');
        setState(() => _isGoogleLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Google sign-in cancelled or failed. Please check your Google Cloud Console configuration.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        return;
      }

      if (googleData != null) {
        print('Sending to backend...');
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final result = await authProvider.socialLogin(
          provider: googleData['provider'],
          providerId: googleData['provider_id'],
          name: googleData['name'],
          email: googleData['email'],
          profileImage: googleData['profile_image'],
        );

        print('Backend response: $result');
        setState(() => _isGoogleLoading = false);

        if (result['success'] && mounted) {
          // Navigate to main screen with bottom navigation
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        } else if (mounted) {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Google sign-in failed'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Exception in _handleGoogleSignIn: $e');
      setState(() => _isGoogleLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-in error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.mainBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      AppAssets.logo,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),
                    // Sign In Title
                    Text(
                      AppStrings.signIn,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle
                    Text(
                      AppStrings.signInSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Phone Field
                    CustomTextField(
                      controller: _phoneController,
                      hintText: AppStrings.enterPhone,
                      labelText: AppStrings.phone,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterPhone;
                        }
                        if (value.length < 10) {
                          return AppStrings.pleaseEnterValidPhone;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: AppStrings.enterPassword,
                      labelText: AppStrings.password,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      showPasswordToggle: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return AppStrings.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          AppStrings.forgotPassword,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    CustomButton(
                      text: AppStrings.login,
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                    // Don't have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.dontHaveAccount,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: Text(
                            AppStrings.signup,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Connect With
                    Text(
                      AppStrings.connectWith,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          imagePath: AppAssets.googleLogo,
                          isGoogle: true,
                          onPressed: _isGoogleLoading
                              ? null
                              : _handleGoogleSignIn,
                        ),
                        const SizedBox(width: 20),
                        SocialLoginButton(
                          imagePath: AppAssets.facebookLogo,
                          isGoogle: false,
                          onPressed: () {
                            // TODO: Implement Facebook Sign In
                          },
                        ),
                      ],
                    ),
                    if (_isGoogleLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Signing in with Google...',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Terms and Privacy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'By signing up you agree to our\nterms & conditions & privacy policy',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
