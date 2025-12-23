import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../features/home/presentation/screens/home_screen_new.dart';
import '../../features/menu/presentation/screens/menu_screen_new.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
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
  int _cartItemCount = 0; // TODO: Connect to cart state management

  // List of screens
  final List<Widget> _screens = [
    const HomeScreenNew(),
    const MenuScreenNew(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        cartItemCount: _cartItemCount,
      ),
    );
  }
}
