/// Category model
import '../../../../core/utils/json_helpers.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? icon;
  final int sortOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      icon: parseStringOrNull(json['icon']),
      sortOrder: parseInt(json['sort_order']),
      isActive: parseBool(json['is_active'], defaultValue: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? icon,
    int? sortOrder,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}
