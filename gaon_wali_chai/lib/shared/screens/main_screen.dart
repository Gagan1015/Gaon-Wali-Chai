import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../features/home/presentation/screens/home_screen_new.dart';
import '../../features/menu/presentation/screens/menu_screen_new.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// Main screen wrapper with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens once
    _screens = [
      const HomeScreenNew(key: PageStorageKey('home')),
      const MenuScreenNew(key: PageStorageKey('menu')),
      CartScreen(
        key: const PageStorageKey('cart'),
        onNavigateToMenu: () {
          setState(() {
            _currentIndex = 1; // Navigate to Menu tab
          });
        },
      ),
      const OrdersScreen(key: PageStorageKey('orders')),
      const ProfileScreen(key: PageStorageKey('profile')),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            cartItemCount: cartProvider.cartCount,
          );
        },
      ),
    );
  }
}
