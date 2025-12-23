import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../data/models/product_size_model.dart';

/// Size selector widget for product detail screen
class SizeSelector extends StatelessWidget {
  final List<ProductSizeModel> sizes;
  final int? selectedSizeId;
  final Function(ProductSizeModel) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSizeId,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Size', style: AppTypography.h5),
        const SizedBox(height: 12),
        Row(
          children: sizes.map((size) {
            final isSelected = selectedSizeId == size.id;
            final isAvailable = size.isAvailable;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: isAvailable ? () => onSizeSelected(size) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : isAvailable
                          ? AppColors.border
                          : AppColors.borderLight,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        size.name,
                        style: AppTypography.body2.copyWith(
                          color: isSelected
                              ? AppColors.textLight
                              : isAvailable
                              ? AppColors.textPrimary
                              : AppColors.textHint,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${size.price.toStringAsFixed(0)}',
                        style: AppTypography.caption.copyWith(
                          color: isSelected
                              ? AppColors.textLight
                              : isAvailable
                              ? AppColors.textSecondary
                              : AppColors.textHint,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
