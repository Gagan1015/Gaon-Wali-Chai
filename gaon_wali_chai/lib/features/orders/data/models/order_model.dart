import 'package:gaon_wali_chai/features/menu/data/models/product_model.dart';

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final String? productImage;
  final double productPrice;
  final String? sizeName;
  final double? sizePrice;
  final int quantity;
  final List<OrderItemVariantModel>? variants;
  final double subtotal;
  final ProductModel? product;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.productPrice,
    this.sizeName,
    this.sizePrice,
    required this.quantity,
    this.variants,
    required this.subtotal,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      productPrice: double.parse(json['product_price'].toString()),
      sizeName: json['size_name'],
      sizePrice: json['size_price'] != null
          ? double.parse(json['size_price'].toString())
          : null,
      quantity: json['quantity'],
      variants: json['variants'] != null
          ? (json['variants'] as List)
                .map((v) => OrderItemVariantModel.fromJson(v))
                .toList()
          : null,
      subtotal: double.parse(json['subtotal'].toString()),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
}

class OrderItemVariantModel {
  final int id;
  final int orderItemId;
  final String variantName;
  final double additionalPrice;

  OrderItemVariantModel({
    required this.id,
    required this.orderItemId,
    required this.variantName,
    required this.additionalPrice,
  });

  factory OrderItemVariantModel.fromJson(Map<String, dynamic> json) {
    return OrderItemVariantModel(
      id: json['id'],
      orderItemId: json['order_item_id'],
      variantName: json['variant_name'],
      additionalPrice: double.parse(json['additional_price'].toString()),
    );
  }
}

class OrderModel {
  final int id;
  final int userId;
  final String orderNumber;
  final String status;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? specialInstructions;
  final String? deliveryAddress;
  final List<OrderItemModel>? items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.specialInstructions,
    this.deliveryAddress,
    this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      orderNumber: json['order_number'],
      status: json['status'],
      subtotal: double.parse(json['subtotal'].toString()),
      deliveryFee: double.parse(json['delivery_fee'].toString()),
      total: double.parse(json['total'].toString()),
      specialInstructions: json['special_instructions'],
      deliveryAddress: json['delivery_address'],
      items: json['items'] != null
          ? (json['items'] as List)
                .map((i) => OrderItemModel.fromJson(i))
                .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready for Pickup';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
