import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../menu/data/models/category_model.dart';

/// Category chips row for home screen
class CategoryChips extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(CategoryModel) onCategoryTap;

  const CategoryChips({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;

          return Padding(
            padding: EdgeInsets.only(right: 12, left: index == 0 ? 0 : 0),
            child: GestureDetector(
              onTap: () => onCategoryTap(category),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (category.icon != null) ...[
                      Icon(
                        _getCategoryIcon(category.name),
                        size: 18,
                        color: isSelected
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      category.name,
                      style: AppTypography.body2.copyWith(
                        color: isSelected
                            ? AppColors.textLight
                            : AppColors.textPrimary,
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
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('tea') || name.contains('chai')) {
      return Icons.local_cafe;
    } else if (name.contains('snack')) {
      return Icons.fastfood;
    } else if (name.contains('dessert') || name.contains('sweet')) {
      return Icons.cake;
    } else if (name.contains('drink') || name.contains('shake')) {
      return Icons.local_drink;
    }
    return Icons.restaurant_menu;
  }
}
