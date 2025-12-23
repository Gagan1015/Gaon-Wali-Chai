import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/error_widget.dart';

/// Cart screen - Shopping cart
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Cart', showBackButton: false),
      body: const EmptyStateWidget(
        message: 'Your cart is empty\nAdd items from the menu',
        icon: Icons.shopping_cart_outlined,
        actionText: 'Browse Menu',
      ),
    );
  }
}
