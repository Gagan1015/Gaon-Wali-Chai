import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/product_variant_model.dart';

/// Variant item widget for product detail screen
class VariantItem extends StatelessWidget {
  final ProductVariantModel variant;
  final bool isSelected;
  final Function(ProductVariantModel) onToggle;

  const VariantItem({
    super.key,
    required this.variant,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: variant.isAvailable ? () => onToggle(variant) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Variant image
            if (variant.image != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.borderLight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    variant.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_outlined,
                        color: AppColors.textHint,
                      );
                    },
                  ),
                ),
              ),
            if (variant.image != null) const SizedBox(width: 12),

            // Variant info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.name,
                    style: AppTypography.body2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Helpers.formatPrice(variant.price),
                    style: AppTypography.body3.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.textLight,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Variants list widget
class VariantsList extends StatelessWidget {
  final List<ProductVariantModel> variants;
  final Set<int> selectedVariantIds;
  final Function(ProductVariantModel) onVariantToggle;

  const VariantsList({
    super.key,
    required this.variants,
    required this.selectedVariantIds,
    required this.onVariantToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customize Your Order', style: AppTypography.h5),
        const SizedBox(height: 4),
        Text(
          'Select add-ons (optional)',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        ...variants.map((variant) {
          return VariantItem(
            variant: variant,
            isSelected: selectedVariantIds.contains(variant.id),
            onToggle: onVariantToggle,
          );
        }),
      ],
    );
  }
}
