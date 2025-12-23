import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Hero Image - Chai with splash
              Image.asset(AppAssets.heroPage, height: 250, fit: BoxFit.contain),
              const SizedBox(height: 40),
              // Welcome Text
              Text(
                AppStrings.welcomeTo,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Logo
              Image.asset(AppAssets.logo, height: 80, fit: BoxFit.contain),
              const Spacer(),
              // Register Button
              CustomButton(
                text: AppStrings.register,
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              // Login Button
              CustomButton(
                text: AppStrings.login,
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                backgroundColor: AppColors.buttonPrimary,
                textColor: Colors.white,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
