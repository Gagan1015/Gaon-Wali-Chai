import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full screen PageView
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // First Slide
              _buildSlide(
                image: AppAssets.slide1,
                title: 'Find the best Chai\nfor you',
                isDark: true,
              ),
              // Second Slide
              _buildSlide(
                image: AppAssets.slide2,
                title: 'Find the best Chai\nfor you',
                isDark: true,
              ),
              // Third Slide - Welcome/Login Register
              _buildWelcomeSlide(),
            ],
          ),
          // Bottom controls with SafeArea
          // Bottom controls with SafeArea (hide on third slide)
          if (_currentPage != 2)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pagination Dots
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => _buildDot(isActive: index == _currentPage),
                        ),
                      ),
                    ),
                    // Next Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CustomButton(
                        text: 'Next',
                        onPressed: _nextPage,
                        backgroundColor: AppColors.buttonPrimary,
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String image,
    required String title,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSlide() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.mainBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              // Cup Image
              Flexible(
                flex: 3,
                child: Image.asset(AppAssets.whiteTeaCup, fit: BoxFit.contain),
              ),
              const SizedBox(height: 20),
              // Welcome Text and Logo
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.welcomeTo,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    AppAssets.logo,
                    width: 208,
                    height: 151,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    text: AppStrings.register,
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: AppStrings.login,
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    backgroundColor: AppColors.buttonPrimary,
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
