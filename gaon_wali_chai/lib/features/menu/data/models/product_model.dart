import 'category_model.dart';
import 'product_size_model.dart';
import 'product_variant_model.dart';

/// Product model
class ProductModel {
  final int id;
  final String name;
  final String description;
  final double basePrice;
  final String image;
  final CategoryModel? category;
  final List<ProductSizeModel> sizes;
  final List<ProductVariantModel> variants;
  final bool isFeatured;
  final bool isAvailable;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.image,
    this.category,
    this.sizes = const [],
    this.variants = const [],
    this.isFeatured = false,
    this.isAvailable = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      basePrice: (json['base_price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      sizes: json['sizes'] != null
          ? (json['sizes'] as List)
                .map(
                  (size) =>
                      ProductSizeModel.fromJson(size as Map<String, dynamic>),
                )
                .toList()
          : [],
      variants: json['variants'] != null
          ? (json['variants'] as List)
                .map(
                  (variant) => ProductVariantModel.fromJson(
                    variant as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      isFeatured: json['is_featured'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'image': image,
      'category': category?.toJson(),
      'sizes': sizes.map((size) => size.toJson()).toList(),
      'variants': variants.map((variant) => variant.toJson()).toList(),
      'is_featured': isFeatured,
      'is_available': isAvailable,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? basePrice,
    String? image,
    CategoryModel? category,
    List<ProductSizeModel>? sizes,
    List<ProductVariantModel>? variants,
    bool? isFeatured,
    bool? isAvailable,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      image: image ?? this.image,
      category: category ?? this.category,
      sizes: sizes ?? this.sizes,
      variants: variants ?? this.variants,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  /// Get the lowest price (base price or smallest size price)
  double get lowestPrice {
    if (sizes.isEmpty) return basePrice;
    final sortedSizes = List<ProductSizeModel>.from(sizes)
      ..sort((a, b) => a.price.compareTo(b.price));
    return sortedSizes.first.price;
  }
}
