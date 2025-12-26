/// Product size model
import '../../../../core/utils/json_helpers.dart';

class ProductSizeModel {
  final int id;
  final int productId;
  final String name;
  final double price;
  final bool isAvailable;

  ProductSizeModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.isAvailable = true,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      id: parseInt(json['id']),
      productId: parseInt(json['product_id']),
      name: parseString(json['name']),
      price: parseDouble(json['price']),
      isAvailable: parseBool(json['is_available'], defaultValue: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'is_available': isAvailable,
    };
  }
}
