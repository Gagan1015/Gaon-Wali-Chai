import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/category_tab_bar.dart';
import '../widgets/product_grid.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import 'product_detail_screen.dart';

/// Menu screen - Product listing with categories
class MenuScreenNew extends StatefulWidget {
  const MenuScreenNew({super.key});

  @override
  State<MenuScreenNew> createState() => _MenuScreenNewState();
}

class _MenuScreenNewState extends State<MenuScreenNew> {
  int selectedCategoryId = 1;
  bool isLoading = false;
  String? errorMessage;

  // Mock data - Replace with actual API calls later
  final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: 'All', sortOrder: 0),
    CategoryModel(id: 2, name: 'Hot Drinks', sortOrder: 1),
    CategoryModel(id: 3, name: 'Kulhad Chai', sortOrder: 2),
    CategoryModel(id: 4, name: 'Snacks', sortOrder: 3),
    CategoryModel(id: 5, name: 'Desserts', sortOrder: 4),
    CategoryModel(id: 6, name: 'Cold Drinks', sortOrder: 5),
  ];

  final List<ProductModel> _allProducts = [
    ProductModel(
      id: 1,
      name: 'Kulhad Chai',
      description: 'Traditional Indian tea served in kulhad',
      basePrice: 50,
      image:
          'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 2,
      name: 'Masala Tea',
      description: 'Spiced tea with authentic Indian masala',
      basePrice: 60,
      image:
          'https://images.unsplash.com/photo-1597318493728-0e6ac91c189e?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 3,
      name: 'Ginger Tea',
      description: 'Refreshing tea with fresh ginger',
      basePrice: 55,
      image:
          'https://images.unsplash.com/photo-1576092768792-7e1b1b8e6205?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 4,
      name: 'Elaichi Tea',
      description: 'Cardamom flavored aromatic tea',
      basePrice: 55,
      image:
          'https://images.unsplash.com/photo-1597318493728-0e6ac91c189e?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 5,
      name: 'Samosa',
      description: 'Crispy fried pastry with savory filling',
      basePrice: 30,
      image:
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 6,
      name: 'Pakora',
      description: 'Deep fried fritters, perfect with tea',
      basePrice: 40,
      image:
          'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 7,
      name: 'Gulab Jamun',
      description: 'Sweet milk-solid based dessert',
      basePrice: 45,
      image:
          'https://images.unsplash.com/photo-1639744091413-f28cd22ed8b4?w=400',
      isAvailable: true,
    ),
    ProductModel(
      id: 8,
      name: 'Jalebi',
      description: 'Sweet, crispy, and syrupy dessert',
      basePrice: 50,
      image:
          'https://images.unsplash.com/photo-1639744091413-f28cd22ed8b4?w=400',
      isAvailable: false,
    ),
  ];

  List<ProductModel> get _filteredProducts {
    if (selectedCategoryId == 1) {
      return _allProducts;
    }
    // TODO: Filter by actual category when backend is ready
    return _allProducts;
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
                  selectedCategoryId: selectedCategoryId,
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
    // TODO: Fetch products for selected category
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
    // TODO: Add product to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: AppColors.textLight,
          onPressed: () {
            // TODO: Navigate to cart
          },
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // TODO: Fetch data from API
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
