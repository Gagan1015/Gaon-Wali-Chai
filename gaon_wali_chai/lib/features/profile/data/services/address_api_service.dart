import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

/// Address API Service
class AddressApiService {
  final ApiService _api = ApiService();

  // Get all addresses
  Future<ApiResponse> getAddresses() async {
    return await _api.get(ApiConfig.addresses, requiresAuth: true);
  }

  // Create address
  Future<ApiResponse> createAddress({
    required String label,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String pincode,
    bool isDefault = false,
  }) async {
    final body = {
      'label': label,
      'address_line1': addressLine1,
      if (addressLine2 != null && addressLine2.isNotEmpty)
        'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'is_default': isDefault,
    };

    return await _api.post(ApiConfig.addresses, body, requiresAuth: true);
  }

  // Get address details
  Future<ApiResponse> getAddressDetails(int addressId) async {
    return await _api.get(
      '${ApiConfig.addresses}/$addressId',
      requiresAuth: true,
    );
  }

  // Update address
  Future<ApiResponse> updateAddress(
    int addressId, {
    String? label,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    bool? isDefault,
  }) async {
    final body = <String, dynamic>{};
    if (label != null) body['label'] = label;
    if (addressLine1 != null) body['address_line1'] = addressLine1;
    if (addressLine2 != null) body['address_line2'] = addressLine2;
    if (city != null) body['city'] = city;
    if (state != null) body['state'] = state;
    if (pincode != null) body['pincode'] = pincode;
    if (isDefault != null) body['is_default'] = isDefault;

    return await _api.put(
      '${ApiConfig.addresses}/$addressId',
      body,
      requiresAuth: true,
    );
  }

  // Delete address
  Future<ApiResponse> deleteAddress(int addressId) async {
    return await _api.delete(
      '${ApiConfig.addresses}/$addressId',
      requiresAuth: true,
    );
  }
}
