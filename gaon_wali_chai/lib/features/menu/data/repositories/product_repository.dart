import '../services/product_api_service.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../../../../core/utils/api_response.dart';

/// Product Repository
class ProductRepository {
  final ProductApiService _apiService = ProductApiService();

  // Get categories
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _apiService.getCategories();

      if (response.success) {
        final data = response.data as Map<String, dynamic>;
        final categoriesJson = data['data'] as List;
        final categories = categoriesJson
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        return ApiResponse.success(categories);
      }

      return ApiResponse.error(response.message ?? 'Failed to get categories');
    } catch (e) {
      return ApiResponse.error('Error parsing categories: ${e.toString()}');
    }
  }

  // Get products
  Future<ApiResponse<List<ProductModel>>> getProducts({
    int? categoryId,
    bool? featured,
    String? search,
  }) async {
    try {
      final response = await _apiService.getProducts(
        categoryId: categoryId,
        featured: featured,
        search: search,
      );

      if (response.success) {
        final data = response.data as Map<String, dynamic>;
        final productsJson = data['data'] as List;
        final products = productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();

        return ApiResponse.success(products);
      }

      return ApiResponse.error(response.message ?? 'Failed to get products');
    } catch (e) {
      return ApiResponse.error('Error parsing products: ${e.toString()}');
    }
  }

  // Get product details
  Future<ApiResponse<ProductModel>> getProductDetails(int productId) async {
    final response = await _apiService.getProductDetails(productId);

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final product = ProductModel.fromJson(data['data']);

      return ApiResponse.success(product);
    }

    return ApiResponse.error(response.message ?? 'Failed to get product');
  }
}
