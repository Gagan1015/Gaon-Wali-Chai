import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/welcome_screen.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/auth/presentation/screens/verify_code_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/profile/presentation/screens/addresses_screen.dart';
import 'features/profile/presentation/screens/add_edit_address_screen.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/profile/data/models/address_model.dart';
import 'features/checkout/presentation/screens/checkout_screen.dart';
import 'features/orders/presentation/screens/order_detail_screen.dart';
import 'shared/screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => CartProvider()..initialize()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaonwali Chai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle routes with arguments
        if (settings.name == '/main') {
          final int initialIndex = settings.arguments as int? ?? 0;
          return MaterialPageRoute(
            builder: (context) => MainScreen(initialIndex: initialIndex),
          );
        }

        // Handle add/edit address route
        if (settings.name == '/add-edit-address') {
          final AddressModel? address = settings.arguments as AddressModel?;
          return MaterialPageRoute(
            builder: (context) => AddEditAddressScreen(address: address),
          );
        }

        // Handle order detail route
        if (settings.name == '/order-detail') {
          final String orderNumber = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => OrderDetailScreen(orderNumber: orderNumber),
          );
        }

        return null;
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/verify-code': (context) => const VerifyCodeScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/addresses': (context) => const AddressesScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/checkout': (context) => const CheckoutScreen(),
      },
    );
  }
}
