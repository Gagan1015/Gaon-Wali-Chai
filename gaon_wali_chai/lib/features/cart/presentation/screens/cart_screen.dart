import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/confirmation_bottom_sheet.dart';
import '../../data/models/cart_item_model.dart';
import '../providers/cart_provider.dart';

/// Cart screen - Shopping cart
class CartScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMenu;

  const CartScreen({super.key, this.onNavigateToMenu});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final StorageService _storageService = StorageService();
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final hasToken = await _storageService.hasToken();
    setState(() {
      isAuthenticated = hasToken;
    });

    if (hasToken && mounted) {
      // Load cart using provider
      context.read<CartProvider>().loadCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Cart', showBackButton: false),
      body: !isAuthenticated
          ? EmptyStateWidget(
              message: 'Please login to view your cart',
              icon: Icons.login,
              actionText: 'Login',
              onAction: () {
                Navigator.pushNamed(context, '/signin');
              },
            )
          : Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                if (cartProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (cartProvider.errorMessage != null) {
                  return EmptyStateWidget(
                    message: cartProvider.errorMessage!,
                    icon: Icons.error_outline,
                    actionText: 'Retry',
                    onAction: () => cartProvider.loadCart(),
                  );
                }

                if (cartProvider.isEmpty) {
                  return EmptyStateWidget(
                    message: 'Your cart is empty\nAdd items from the menu',
                    icon: Icons.shopping_cart_outlined,
                    actionText: 'Browse Menu',
                    onAction: () {
                      widget.onNavigateToMenu?.call();
                    },
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          return _CartItemTile(
                            cartItem: cartProvider.cartItems[index],
                            onQuantityChanged: (cartItemId, quantity) async {
                              await cartProvider.updateCartItem(
                                cartItemId,
                                quantity,
                              );
                            },
                            onRemove: (cartItemId) {
                              final cartItem = cartProvider.cartItems
                                  .firstWhere((item) => item.id == cartItemId);
                              ConfirmationBottomSheet.show(
                                context: context,
                                title: 'Remove Item?',
                                message:
                                    'Are you sure you want to remove "${cartItem.product?.name ?? 'this item'}" from your cart?',
                                confirmText: 'Remove',
                                cancelText: 'Cancel',
                                isDangerous: true,
                                onConfirm: () async {
                                  await cartProvider.removeCartItem(cartItemId);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _buildBottomBar(cartProvider),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriceRow('Subtotal', cartProvider.subtotal),
              const SizedBox(height: 8),
              _buildPriceRow('Delivery Fee', cartProvider.deliveryFee),
              const SizedBox(height: 8),
              _buildPriceRow('Tax', cartProvider.tax),
              const Divider(height: 24),
              _buildPriceRow('Total', cartProvider.grandTotal, isTotal: true),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Proceed to Checkout',
                onPressed: _proceedToCheckout,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTypography.h5 : AppTypography.body2),
        Text(
          Helpers.formatPrice(amount),
          style: isTotal
              ? AppTypography.h4.copyWith(color: AppColors.primary)
              : AppTypography.body2.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void _proceedToCheckout() {
    // TODO: Navigate to checkout/address selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel cartItem;
  final Function(int, int) onQuantityChanged;
  final void Function(int) onRemove;

  const _CartItemTile({
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    if (product == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.borderLight,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.fastfood,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.h6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (cartItem.size != null)
                    Text(
                      'Size: ${cartItem.size!.name}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (cartItem.variants != null &&
                      cartItem.variants!.isNotEmpty)
                    Text(
                      'Variants: ${cartItem.variants!.map((v) => v.name).join(', ')}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        Helpers.formatPrice(cartItem.calculateTotal()),
                        style: AppTypography.body1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Quantity controls
                      _buildQuantityControls(),
                    ],
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onRemove(cartItem.id),
              color: AppColors.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            Icons.remove,
            () => cartItem.quantity > 1
                ? onQuantityChanged(cartItem.id, cartItem.quantity - 1)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${cartItem.quantity}',
              style: AppTypography.body2.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          _buildQuantityButton(
            Icons.add,
            () => onQuantityChanged(cartItem.id, cartItem.quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback? onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? AppColors.primary : AppColors.textTertiary,
        ),
      ),
    );
  }
}
