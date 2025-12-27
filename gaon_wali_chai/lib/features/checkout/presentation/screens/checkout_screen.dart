import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../profile/data/models/address_model.dart';
import '../../../profile/data/repositories/address_repository.dart';
import '../../../orders/data/repositories/order_repository.dart';
import '../widgets/address_selection_sheet.dart';

/// Checkout Screen
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final AddressRepository _addressRepository = AddressRepository();
  final OrderRepository _orderRepository = OrderRepository();

  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;
  String _selectedPaymentMethod = 'upi';
  bool _isLoadingAddresses = true;
  bool _isPlacingOrder = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'upi',
      'name': 'UPI',
      'subtitle': 'PhonePe, GPay, Paytm & more',
      'icon': Icons.account_balance_wallet,
      'recommended': true,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card,
      'recommended': false,
    },
    {
      'id': 'cod',
      'name': 'Cash on Delivery',
      'subtitle': 'Pay when you receive',
      'icon': Icons.money,
      'recommended': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoadingAddresses = true);

    final response = await _addressRepository.getAddresses();

    if (response.success && response.data != null) {
      setState(() {
        _addresses = response.data!;
        // Select default address or first address
        _selectedAddress = _addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => _addresses.first,
        );
        _isLoadingAddresses = false;
      });
    } else {
      setState(() => _isLoadingAddresses = false);
    }
  }

  Future<void> _changeAddress() async {
    final selected = await AddressSelectionSheet.show(
      context: context,
      addresses: _addresses,
      selectedAddress: _selectedAddress,
    );

    if (selected != null) {
      setState(() => _selectedAddress = selected);
    } else {
      // User might have added a new address, reload
      _loadAddresses();
    }
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final cartProvider = context.read<CartProvider>();

    // Refresh cart to ensure it's synced with backend
    await cartProvider.loadCart();

    if (cartProvider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final response = await _orderRepository.createOrder(
        paymentMethod: _selectedPaymentMethod,
        deliveryAddressId: _selectedAddress!.id,
        specialInstructions: null,
      );

      if (mounted) {
        setState(() => _isPlacingOrder = false);

        if (response.success) {
          // Clear cart
          await cartProvider.clearCart();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: AppColors.matchaGreen,
                duration: Duration(seconds: 2),
              ),
            );

            // Navigate to orders screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
              (route) => false,
              arguments: 3, // Orders tab
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to place order'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Checkout', showBackButton: true),
      body: _isLoadingAddresses
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCartSummary(),
                        const SizedBox(height: 24),
                        _buildAddressSection(),
                        const SizedBox(height: 24),
                        _buildPaymentMethodSection(),
                        const SizedBox(height: 24),
                        _buildOrderSummary(),
                      ],
                    ),
                  ),
                ),
                _buildPlaceOrderButton(),
              ],
            ),
    );
  }

  Widget _buildCartSummary() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cart Items',
                    style: AppTypography.h6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Edit Cart',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              ...cartProvider.cartItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.local_cafe, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product?.name ?? 'Product',
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Qty: ${item.quantity}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${item.calculateTotal().toStringAsFixed(0)}',
                        style: AppTypography.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _changeAddress,
                child: Text(
                  'Change',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          if (_selectedAddress != null) ...[
            Row(
              children: [
                Icon(
                  _selectedAddress!.labelIcon,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedAddress!.label,
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                if (_selectedAddress!.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.matchaGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.matchaGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _selectedAddress!.fullAddress,
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ] else ...[
            Text(
              'No address selected',
              style: AppTypography.body2.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 16),
          ..._paymentMethods.map(
            (method) => InkWell(
              onTap: () =>
                  setState(() => _selectedPaymentMethod = method['id']),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedPaymentMethod == method['id']
                      ? AppColors.primaryLight.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedPaymentMethod == method['id']
                        ? AppColors.primary
                        : AppColors.border,
                    width: _selectedPaymentMethod == method['id'] ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedPaymentMethod == method['id']
                            ? AppColors.primary
                            : AppColors.surface,
                        border: Border.all(
                          color: _selectedPaymentMethod == method['id']
                              ? AppColors.primary
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: _selectedPaymentMethod == method['id']
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Icon(method['icon'], color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                method['name'],
                                style: AppTypography.body1.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (method['recommended']) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.matchaGreen.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'RECOMMENDED',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.matchaGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            method['subtitle'],
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final subtotal = cartProvider.subtotal;
        const deliveryFee = 20.0;
        final tax = subtotal * 0.05; // 5% tax
        final total = subtotal + deliveryFee + tax;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Summary',
                style: AppTypography.h6.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 16),
              _buildSummaryRow('Subtotal', subtotal),
              const SizedBox(height: 8),
              _buildSummaryRow('Delivery Fee', deliveryFee),
              const SizedBox(height: 8),
              _buildSummaryRow('Tax (5%)', tax),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.h6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: AppTypography.h5.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final total =
            cartProvider.subtotal + 20 + (cartProvider.subtotal * 0.05);

        return Container(
          padding: const EdgeInsets.all(16),
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
            child: CustomButton(
              text: 'Place Order • ₹${total.toStringAsFixed(0)}',
              onPressed: () {
                _placeOrder();
              },
              isLoading: _isPlacingOrder,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }
}
