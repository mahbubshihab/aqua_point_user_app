import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final String? imageUrl;
  final int productCount;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
    this.productCount = 0,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? icon,
    String? imageUrl,
    int? productCount,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, imageUrl, productCount];
}
