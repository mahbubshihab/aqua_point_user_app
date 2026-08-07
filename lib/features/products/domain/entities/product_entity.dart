import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? photoUrl;
  final String warrantyDetails;
  final String purchaseDate;
  final bool isCustom;

  const ProductEntity({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.warrantyDetails,
    required this.purchaseDate,
    this.isCustom = false,
  });

  ProductEntity copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? warrantyDetails,
    String? purchaseDate,
    bool? isCustom,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      warrantyDetails: warrantyDetails ?? this.warrantyDetails,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        photoUrl,
        warrantyDetails,
        purchaseDate,
        isCustom,
      ];
}
