import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/error_widget.dart';

/// Orders screen - Order history
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'My Orders', showBackButton: false),
      body: const EmptyStateWidget(
        message: 'No orders yet\nStart ordering your favorite chai',
        icon: Icons.receipt_long_outlined,
        actionText: 'Order Now',
      ),
    );
  }
}
