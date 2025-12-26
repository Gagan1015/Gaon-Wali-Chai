class AddressModel {
  final int id;
  final int userId;
  final String type;
  final String streetAddress;
  final String? apartment;
  final String? landmark;
  final String city;
  final String state;
  final String pincode;
  final String? phoneNumber;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.streetAddress,
    this.apartment,
    this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    this.phoneNumber,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      streetAddress: json['street_address'],
      apartment: json['apartment'],
      landmark: json['landmark'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      phoneNumber: json['phone_number'],
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'street_address': streetAddress,
      'apartment': apartment,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phone_number': phoneNumber,
      'is_default': isDefault,
    };
  }

  String get fullAddress {
    List<String> parts = [streetAddress];
    if (apartment != null) parts.add(apartment!);
    if (landmark != null) parts.add('Near $landmark');
    parts.add('$city, $state - $pincode');
    return parts.join(', ');
  }

  String get typeDisplay {
    switch (type) {
      case 'home':
        return 'Home';
      case 'work':
        return 'Work';
      case 'other':
        return 'Other';
      default:
        return type;
    }
  }
}
