import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../widgets/promo_banner.dart';
import '../widgets/category_chips.dart';
import '../widgets/featured_products_section.dart';
import '../../../menu/data/models/category_model.dart';
import '../../../menu/data/models/product_model.dart';
import '../../../menu/data/models/product_size_model.dart';
import '../../../menu/data/models/product_variant_model.dart';
import '../../../menu/presentation/screens/product_detail_screen.dart';

/// Home screen - Main landing page
class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int? selectedCategoryId;
  bool isLoading = false;

  // Mock data - Replace with actual API calls later
  final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: 'Kulhad Tea', sortOrder: 1),
    CategoryModel(id: 2, name: 'Snacks', sortOrder: 2),
    CategoryModel(id: 3, name: 'Desserts', sortOrder: 3),
    CategoryModel(id: 4, name: 'Cold Drinks', sortOrder: 4),
  ];

  final List<ProductModel> _featuredProducts = [
    ProductModel(
      id: 1,
      name: 'Kulhad Chai',
      description: 'Traditional Indian tea served in kulhad',
      basePrice: 50,
      image:
          'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400',
      sizes: [
        ProductSizeModel(id: 1, productId: 1, name: 'Small', price: 50),
        ProductSizeModel(id: 2, productId: 1, name: 'Medium', price: 70),
        ProductSizeModel(id: 3, productId: 1, name: 'Large', price: 90),
      ],
      variants: [
        ProductVariantModel(id: 1, productId: 1, name: 'Extra Sugar', price: 5),
        ProductVariantModel(id: 2, productId: 1, name: 'Elaichi', price: 10),
        ProductVariantModel(id: 3, productId: 1, name: 'Ginger', price: 10),
      ],
      isFeatured: true,
      isAvailable: true,
    ),
    ProductModel(
      id: 2,
      name: 'Masala Tea',
      description: 'Spiced tea with authentic Indian masala',
      basePrice: 60,
      image:
          'https://images.unsplash.com/photo-1597318493728-0e6ac91c189e?w=400',
      sizes: [
        ProductSizeModel(id: 4, productId: 2, name: 'Small', price: 60),
        ProductSizeModel(id: 5, productId: 2, name: 'Medium', price: 80),
        ProductSizeModel(id: 6, productId: 2, name: 'Large', price: 100),
      ],
      variants: [
        ProductVariantModel(id: 4, productId: 2, name: 'Less Spicy', price: 0),
        ProductVariantModel(id: 5, productId: 2, name: 'Extra Spicy', price: 5),
      ],
      isFeatured: true,
      isAvailable: true,
    ),
    ProductModel(
      id: 3,
      name: 'Ginger Tea',
      description: 'Refreshing tea with fresh ginger',
      basePrice: 55,
      image:
          'https://images.unsplash.com/photo-1576092768792-7e1b1b8e6205?w=400',
      isFeatured: true,
      isAvailable: true,
    ),
    ProductModel(
      id: 4,
      name: 'Samosa',
      description: 'Crispy fried pastry with savory filling',
      basePrice: 30,
      image:
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400',
      isFeatured: true,
      isAvailable: true,
    ),
  ];

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
    // TODO: Add product to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW',
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
