import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/api_response.dart';

/// Address API Service
class AddressApiService {
  final ApiService _api = ApiService();

  // Get all addresses
  Future<ApiResponse> getAddresses() async {
    return await _api.get(ApiConfig.addresses);
  }

  // Create address
  Future<ApiResponse> createAddress({
    required String type,
    required String streetAddress,
    String? apartment,
    String? landmark,
    required String city,
    required String state,
    required String pincode,
    String? phoneNumber,
    bool isDefault = false,
  }) async {
    final body = {
      'type': type,
      'street_address': streetAddress,
      if (apartment != null) 'apartment': apartment,
      if (landmark != null) 'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      'is_default': isDefault,
    };

    return await _api.post(ApiConfig.addresses, body);
  }

  // Get address details
  Future<ApiResponse> getAddressDetails(int addressId) async {
    return await _api.get('${ApiConfig.addresses}/$addressId');
  }

  // Update address
  Future<ApiResponse> updateAddress(
    int addressId, {
    String? type,
    String? streetAddress,
    String? apartment,
    String? landmark,
    String? city,
    String? state,
    String? pincode,
    String? phoneNumber,
    bool? isDefault,
  }) async {
    final body = <String, dynamic>{};
    if (type != null) body['type'] = type;
    if (streetAddress != null) body['street_address'] = streetAddress;
    if (apartment != null) body['apartment'] = apartment;
    if (landmark != null) body['landmark'] = landmark;
    if (city != null) body['city'] = city;
    if (state != null) body['state'] = state;
    if (pincode != null) body['pincode'] = pincode;
    if (phoneNumber != null) body['phone_number'] = phoneNumber;
    if (isDefault != null) body['is_default'] = isDefault;

    return await _api.put('${ApiConfig.addresses}/$addressId', body);
  }

  // Delete address
  Future<ApiResponse> deleteAddress(int addressId) async {
    return await _api.delete('${ApiConfig.addresses}/$addressId');
  }
}
