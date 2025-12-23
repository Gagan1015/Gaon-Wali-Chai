/// Product variant/add-on model
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
      id: json['id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
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
