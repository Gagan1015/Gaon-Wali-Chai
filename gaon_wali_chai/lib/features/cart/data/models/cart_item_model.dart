import 'package:gaon_wali_chai/features/menu/data/models/product_model.dart';
import 'package:gaon_wali_chai/features/menu/data/models/product_size_model.dart';
import 'package:gaon_wali_chai/features/menu/data/models/product_variant_model.dart';
import '../../../../core/utils/json_helpers.dart';

class CartItemModel {
  final int id;
  final int userId;
  final int productId;
  final int? sizeId;
  final int quantity;
  final ProductModel? product;
  final ProductSizeModel? size;
  final List<ProductVariantModel>? variants;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    this.sizeId,
    required this.quantity,
    this.product,
    this.size,
    this.variants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      productId: parseInt(json['product_id']),
      sizeId: parseIntOrNull(json['size_id']),
      quantity: parseInt(json['quantity']),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      size: json['size'] != null
          ? ProductSizeModel.fromJson(json['size'])
          : null,
      variants: json['variants'] != null
          ? (json['variants'] as List)
                .map((v) => ProductVariantModel.fromJson(v))
                .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'size_id': sizeId,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Calculate total for this cart item
  double calculateTotal() {
    if (product == null) return 0.0;

    double basePrice = product!.basePrice;

    // Add size price if applicable
    if (size != null) {
      basePrice = size!.price;
    }

    // Add variants price
    double variantsPrice = 0.0;
    if (variants != null) {
      variantsPrice = variants!.fold(
        0.0,
        (sum, variant) => sum + variant.price,
      );
    }

    return (basePrice + variantsPrice) * quantity;
  }
}
