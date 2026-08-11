import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String? photoUrl;
  final List<String> images;
  final String warrantyDetails;
  final String purchaseDate;
  final bool isCustom;
  final double price;
  final double? originalPrice;
  final String? category;
  final String? type;
  final double? rating;
  final int? reviewsCount;
  final String? description;
  final bool inStock;

  const ProductEntity({
    required this.id,
    required this.name,
    this.photoUrl,
    this.images = const [],
    this.warrantyDetails = '1 Year Warranty',
    this.purchaseDate = 'Active',
    this.isCustom = false,
    this.price = 1250.0,
    this.originalPrice,
    this.category,
    this.type,
    this.rating,
    this.reviewsCount,
    this.description,
    this.inStock = true,
  });

  List<String> get allImages {
    if (images.isNotEmpty) return images;
    if (photoUrl != null && photoUrl!.isNotEmpty) return [photoUrl!];
    return [];
  }

  ProductEntity copyWith({
    String? id,
    String? name,
    String? photoUrl,
    List<String>? images,
    String? warrantyDetails,
    String? purchaseDate,
    bool? isCustom,
    double? price,
    double? originalPrice,
    String? category,
    String? type,
    double? rating,
    int? reviewsCount,
    String? description,
    bool? inStock,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      images: images ?? this.images,
      warrantyDetails: warrantyDetails ?? this.warrantyDetails,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      isCustom: isCustom ?? this.isCustom,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      description: description ?? this.description,
      inStock: inStock ?? this.inStock,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        photoUrl,
        images,
        warrantyDetails,
        purchaseDate,
        isCustom,
        price,
        originalPrice,
        category,
        type,
        rating,
        reviewsCount,
        description,
        inStock,
      ];
}
