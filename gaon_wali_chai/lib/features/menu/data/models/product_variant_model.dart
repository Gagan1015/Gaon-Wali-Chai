/// Product variant/add-on model
import '../../../../core/utils/json_helpers.dart';

class ProductVariantModel {
  final int id;
  final int productId;
  final String name;
  final double price;
  final String? image;
  final bool isAvailable;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.image,
    this.isAvailable = true,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: parseInt(json['id']),
      productId: parseInt(json['product_id']),
      name: parseString(json['name']),
      price: parseDouble(json['price']),
      image: parseStringOrNull(json['image']),
      isAvailable: parseBool(json['is_available'], defaultValue: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'image': image,
      'is_available': isAvailable,
    };
  }
}
