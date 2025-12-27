import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

/// Order Detail Screen - Shows detailed information about a specific order
class OrderDetailScreen extends StatefulWidget {
  final String orderNumber;

  const OrderDetailScreen({super.key, required this.orderNumber});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  bool _isLoading = false;
  OrderModel? _order;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await _orderRepository.getOrderDetails(widget.orderNumber);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (response.success && response.data != null) {
        _order = response.data;
      } else {
        _error = response.message ?? 'Failed to load order details';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Order #${widget.orderNumber}',
        showBackButton: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrderDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_order == null) {
      return const Center(child: Text('Order not found'));
    }

    final statusColor = _getStatusColor(_order!.status);
    final statusLabel = Helpers.getOrderStatusLabel(_order!.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  _getStatusIcon(_order!.status),
                  size: 48,
                  color: statusColor,
                ),
                const SizedBox(height: 12),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat(
                    'MMM dd, yyyy • hh:mm a',
                  ).format(_order!.createdAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: statusColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Order Items
          _buildSectionTitle('Order Items'),
          const SizedBox(height: 12),
          ..._buildOrderItems(),
          const SizedBox(height: 20),

          // Delivery Address
          if (_order!.deliveryAddress != null) ...[
            _buildSectionTitle('Delivery Address'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              content: _order!.deliveryAddress!,
            ),
            const SizedBox(height: 20),
          ],

          // Special Instructions
          if (_order!.specialInstructions != null &&
              _order!.specialInstructions!.isNotEmpty) ...[
            _buildSectionTitle('Special Instructions'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.note_outlined,
              content: _order!.specialInstructions!,
            ),
            const SizedBox(height: 20),
          ],

          // Order Summary
          _buildSectionTitle('Order Summary'),
          const SizedBox(height: 12),
          _buildSummaryCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  List<Widget> _buildOrderItems() {
    if (_order!.items == null || _order!.items!.isEmpty) {
      return [
        const Text(
          'No items found',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ];
    }

    return _order!.items!.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
                image: item.productImage != null
                    ? DecorationImage(
                        image: NetworkImage(item.productImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: item.productImage == null
                  ? const Icon(Icons.local_cafe, color: AppColors.textSecondary)
                  : null,
            ),
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (item.sizeName != null)
                    Text(
                      'Size: ${item.sizeName}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (item.variants != null && item.variants!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Variants: ${item.variants!.map((v) => v.variantName).join(', ')}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '₹${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInfoCard({required IconData icon, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', _order!.subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Delivery Fee', _order!.deliveryFee),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹${_order!.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return AppColors.matchaGreen;
      case 'preparing':
        return Colors.blue;
      case 'out_for_delivery':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'out_for_delivery':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long;
    }
  }
}
