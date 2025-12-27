import '../services/address_api_service.dart';
import '../models/address_model.dart';
import '../../../../core/utils/api_response.dart';

/// Address Repository
class AddressRepository {
  final AddressApiService _apiService = AddressApiService();

  // Get all addresses
  Future<ApiResponse<List<AddressModel>>> getAddresses() async {
    final response = await _apiService.getAddresses();

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final addressesJson = data['data'] as List;
      final addresses = addressesJson
          .map((json) => AddressModel.fromJson(json))
          .toList();

      return ApiResponse.success(addresses);
    }

    return ApiResponse.error(response.message ?? 'Failed to get addresses');
  }

  // Create address
  Future<ApiResponse<AddressModel>> createAddress({
    required String label,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String pincode,
    bool isDefault = false,
  }) async {
    final response = await _apiService.createAddress(
      label: label,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      pincode: pincode,
      isDefault: isDefault,
    );

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final address = AddressModel.fromJson(data['data']);

      return ApiResponse.success(address);
    }

    return ApiResponse.error(response.message ?? 'Failed to create address');
  }

  // Get address details
  Future<ApiResponse<AddressModel>> getAddressDetails(int addressId) async {
    final response = await _apiService.getAddressDetails(addressId);

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final address = AddressModel.fromJson(data['data']);

      return ApiResponse.success(address);
    }

    return ApiResponse.error(response.message ?? 'Failed to get address');
  }

  // Update address
  Future<ApiResponse<AddressModel>> updateAddress(
    int addressId, {
    String? label,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    bool? isDefault,
  }) async {
    final response = await _apiService.updateAddress(
      addressId,
      label: label,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      pincode: pincode,
      isDefault: isDefault,
    );

    if (response.success) {
      final data = response.data as Map<String, dynamic>;
      final address = AddressModel.fromJson(data['data']);

      return ApiResponse.success(address);
    }

    return ApiResponse.error(response.message ?? 'Failed to update address');
  }

  // Delete address
  Future<ApiResponse<String>> deleteAddress(int addressId) async {
    final response = await _apiService.deleteAddress(addressId);

    if (response.success) {
      return ApiResponse.success('Address deleted successfully');
    }

    return ApiResponse.error(response.message ?? 'Failed to delete address');
  }
}
