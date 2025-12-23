/// Product size model
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
      id: json['id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isAvailable: json['is_available'] as bool? ?? true,
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
