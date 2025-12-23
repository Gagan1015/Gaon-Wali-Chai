import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_typography.dart';

/// Custom bottom navigation bar with cart badge
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartItemCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.restaurant_menu_outlined,
                activeIcon: Icons.restaurant_menu,
                label: 'Menu',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: 'Cart',
                index: 2,
                showBadge: cartItemCount > 0,
                badgeCount: cartItemCount,
              ),
              _buildNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Orders',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final isActive = currentIndex == index;

    Widget navIcon = Icon(
      isActive ? activeIcon : icon,
      color: isActive ? AppColors.primary : AppColors.textSecondary,
      size: 26,
    );

    if (showBadge && badgeCount > 0) {
      navIcon = badges.Badge(
        badgeContent: Text(
          badgeCount > 99 ? '99+' : badgeCount.toString(),
          style: AppTypography.badge,
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: AppColors.badgeBackground,
          padding: EdgeInsets.all(6),
        ),
        position: badges.BadgePosition.topEnd(top: -8, end: -8),
        child: navIcon,
      );
    }

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                navIcon,
                const SizedBox(height: 4),
                Text(
                  label,
                  style: isActive
                      ? AppTypography.captionBold.copyWith(
                          color: AppColors.primary,
                        )
                      : AppTypography.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
