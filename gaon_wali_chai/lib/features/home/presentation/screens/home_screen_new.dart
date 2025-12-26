import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/promo_banner.dart';
import '../widgets/category_chips.dart';
import '../widgets/featured_products_section.dart';
import '../../../menu/data/models/category_model.dart';
import '../../../menu/data/models/product_model.dart';
import '../../../menu/data/repositories/product_repository.dart';
import '../../../menu/presentation/screens/product_detail_screen.dart';

/// Home screen - Main landing page
class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final ProductRepository _productRepository = ProductRepository();

  int? selectedCategoryId;
  bool isLoading = true;
  List<CategoryModel> _categories = [];
  List<ProductModel> _featuredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load categories
      final categoriesResponse = await _productRepository.getCategories();
      if (categoriesResponse.success) {
        _categories = categoriesResponse.data ?? [];
      }

      // Load featured products
      final productsResponse = await _productRepository.getProducts(
        featured: true,
      );
      if (productsResponse.success) {
        _featuredProducts = productsResponse.data ?? [];
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Gaon Wali Chai',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search
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
                // Greeting Section
                _buildGreetingSection(),
                const SizedBox(height: 24),

                // Promo Banner
                PromoBanner(
                  title: 'Special Offer!',
                  subtitle: 'Get 20% off on all kulhad chai',
                  onTap: () {
                    // TODO: Handle banner tap
                  },
                ),
                const SizedBox(height: 24),

                // Categories
                Text('Categories', style: AppTypography.h4),
                const SizedBox(height: 12),
                CategoryChips(
                  categories: _categories,
                  selectedCategoryId: selectedCategoryId,
                  onCategoryTap: _onCategoryTap,
                ),
                const SizedBox(height: 24),

                // Featured Products
                FeaturedProductsSection(
                  products: _featuredProducts,
                  isLoading: isLoading,
                  onProductTap: _onProductTap,
                  onAddToCart: _onAddToCart,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17) {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: AppTypography.h2),
        const SizedBox(height: 4),
        Text(
          'What would you like to have today?',
          style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _onCategoryTap(CategoryModel category) {
    setState(() {
      selectedCategoryId = selectedCategoryId == category.id
          ? null
          : category.id;
    });
    // TODO: Filter products by category or navigate to menu with category filter
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
