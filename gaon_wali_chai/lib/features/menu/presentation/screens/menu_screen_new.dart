import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/product_grid.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import 'product_detail_screen.dart';

/// Menu screen - Product listing with categories
class MenuScreenNew extends StatefulWidget {
  const MenuScreenNew({super.key});

  @override
  State<MenuScreenNew> createState() => _MenuScreenNewState();
}

class _MenuScreenNewState extends State<MenuScreenNew> {
  final ProductRepository _productRepository = ProductRepository();

  int? selectedCategoryId;
  bool isLoading = true;
  String? errorMessage;

  List<CategoryModel> _categories = [];
  List<ProductModel> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List<ProductModel> get _filteredProducts {
    if (selectedCategoryId == null) {
      return _allProducts;
    }
    return _allProducts
        .where((product) => product.categoryId == selectedCategoryId)
        .toList();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Load categories
      final categoriesResponse = await _productRepository.getCategories();

      if (!categoriesResponse.success) {
        throw Exception(categoriesResponse.message);
      }

      // Load products
      final productsResponse = await _productRepository.getProducts();

      if (!productsResponse.success) {
        throw Exception(productsResponse.message);
      }

      if (mounted) {
        setState(() {
          _categories = categoriesResponse.data ?? [];
          _allProducts = productsResponse.data ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString().replaceAll('Exception: ', '');
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Menu',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category tabs
                CategoryTabBar(
                  categories: _categories,
                  selectedCategoryId: selectedCategoryId ?? 0,
                  onCategorySelected: _onCategorySelected,
                ),
                const SizedBox(height: 20),

                // Products count
                Text(
                  '${_filteredProducts.length} Products',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Product grid
                ProductGrid(
                  products: _filteredProducts,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                  onProductTap: _onProductTap,
                  onAddToCart: _onAddToCart,
                  onRetry: _refreshData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCategorySelected(CategoryModel category) {
    setState(() {
      selectedCategoryId = category.id;
    });
  }

  void _onProductTap(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _onAddToCart(ProductModel product) {
    // Navigate to product details to select size/variants
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  Future<void> _refreshData() async {
    await _loadData();
  }
}
