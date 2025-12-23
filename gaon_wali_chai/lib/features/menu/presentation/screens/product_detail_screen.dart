import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../widgets/size_selector.dart';
import '../widgets/variant_item.dart';
import '../../data/models/product_model.dart';
import '../../data/models/product_size_model.dart';
import '../../data/models/product_variant_model.dart';

/// Product detail screen with size and variant selection
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int? selectedSizeId;
  Set<int> selectedVariantIds = {};
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // Auto-select first size if available
    if (widget.product.sizes.isNotEmpty) {
      selectedSizeId = widget.product.sizes.first.id;
    }
  }

  double get totalPrice {
    double price = widget.product.basePrice;

    // Add size price if selected
    if (selectedSizeId != null) {
      final selectedSize = widget.product.sizes.firstWhere(
        (size) => size.id == selectedSizeId,
      );
      price = selectedSize.price;
    }

    // Add variants price
    for (final variant in widget.product.variants) {
      if (selectedVariantIds.contains(variant.id)) {
        price += variant.price;
      }
    }

    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.product.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  _buildProductImage(),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name and Price
                        _buildProductHeader(),
                        const SizedBox(height: 16),

                        // Description
                        if (widget.product.description.isNotEmpty) ...[
                          Text('Description', style: AppTypography.h5),
                          const SizedBox(height: 8),
                          Text(
                            widget.product.description,
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Size Selector
                        if (widget.product.sizes.isNotEmpty) ...[
                          SizeSelector(
                            sizes: widget.product.sizes,
                            selectedSizeId: selectedSizeId,
                            onSizeSelected: _onSizeSelected,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Variants List
                        if (widget.product.variants.isNotEmpty) ...[
                          VariantsList(
                            variants: widget.product.variants,
                            selectedVariantIds: selectedVariantIds,
                            onVariantToggle: _onVariantToggle,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Quantity Selector
                        _buildQuantitySelector(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar with Price and Add to Cart
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'product_${widget.product.id}',
      child: Container(
        height: 300,
        width: double.infinity,
        color: AppColors.borderLight,
        child: Stack(
          children: [
            Image.network(
              widget.product.image,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: AppColors.textHint,
                  ),
                );
              },
            ),
            if (!widget.product.isAvailable)
              Positioned.fill(
                child: Container(
                  color: AppColors.overlay,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Out of Stock',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.product.name, style: AppTypography.h3),
              const SizedBox(height: 8),
              if (widget.product.category != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.product.category!.name,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            Helpers.formatPrice(widget.product.basePrice),
            style: AppTypography.price.copyWith(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text('Quantity', style: AppTypography.h5),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                    : null,
                color: AppColors.primary,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(quantity.toString(), style: AppTypography.h5),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Price', style: AppTypography.caption),
                Text(
                  Helpers.formatPrice(totalPrice),
                  style: AppTypography.h3.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                onPressed: widget.product.isAvailable ? _addToCart : () {},
                isLoading: false,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSizeSelected(ProductSizeModel size) {
    setState(() {
      selectedSizeId = size.id;
    });
  }

  void _onVariantToggle(ProductVariantModel variant) {
    setState(() {
      if (selectedVariantIds.contains(variant.id)) {
        selectedVariantIds.remove(variant.id);
      } else {
        selectedVariantIds.add(variant.id);
      }
    });
  }

  void _addToCart() {
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: AppColors.textLight,
          onPressed: () {
            // TODO: Navigate to cart
          },
        ),
      ),
    );
    Navigator.pop(context);
  }
}
