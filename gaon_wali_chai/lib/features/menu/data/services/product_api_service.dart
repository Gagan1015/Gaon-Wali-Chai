import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

/// Product API Service
class ProductApiService {
  final ApiService _api = ApiService();

  // Get all categories
  Future<ApiResponse> getCategories() async {
    return await _api.get(ApiConfig.categories);
  }

  // Get all products
  Future<ApiResponse> getProducts({
    int? categoryId,
    bool? featured,
    String? search,
    int? page,
    int? perPage,
  }) async {
    String endpoint = ApiConfig.products;
    List<String> queryParams = [];

    if (categoryId != null) queryParams.add('category_id=$categoryId');
    if (featured != null) queryParams.add('featured=$featured');
    if (search != null) queryParams.add('search=$search');
    if (page != null) queryParams.add('page=$page');
    if (perPage != null) queryParams.add('per_page=$perPage');

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    return await _api.get(endpoint);
  }

  // Get product details
  Future<ApiResponse> getProductDetails(int productId) async {
    return await _api.get('${ApiConfig.products}/$productId');
  }
}
