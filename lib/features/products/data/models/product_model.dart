import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    super.photoUrl,
    super.images = const [],
    super.warrantyDetails = '1 Year Warranty',
    super.purchaseDate = 'Active',
    super.isCustom = false,
    super.price = 1250.0,
    super.originalPrice,
    super.category,
    super.type,
    super.rating,
    super.reviewsCount,
    super.description,
    super.inStock = true,
    super.specSections = const [],
    super.features = const [],
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    final rawPrice = map['price'];
    final rawOrigPrice = map['originalPrice'] ?? map['oldPrice'];
    final rawRating = map['rating'];
    final rawReviews = map['reviewsCount'];

    List<String> parsedImages = [];
    if (map['images'] is List) {
      parsedImages = (map['images'] as List)
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    final singlePhoto = map['photoUrl'] ?? map['imageUrl'] ?? map['cloudinary_url'];
    if (parsedImages.isEmpty && singlePhoto != null && singlePhoto.toString().isNotEmpty) {
      parsedImages = [singlePhoto.toString()];
    }

    // Parse Dynamic Spec Sections
    List<SpecSectionEntity> parsedSpecSections = [];
    if (map['specSections'] is List) {
      for (final sec in (map['specSections'] as List)) {
        if (sec is Map) {
          final title = sec['title']?.toString() ?? '';
          final itemsList = sec['items'];
          List<SpecItemEntity> items = [];
          if (itemsList is List) {
            for (final it in itemsList) {
              if (it is Map) {
                items.add(SpecItemEntity(
                  label: it['label']?.toString() ?? '',
                  value: it['value']?.toString() ?? '',
                ));
              }
            }
          }
          parsedSpecSections.add(SpecSectionEntity(
            title: title,
            items: items,
          ));
        }
      }
    }

    // Parse Features
    List<String> parsedFeatures = [];
    if (map['features'] is List) {
      parsedFeatures = (map['features'] as List)
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return ProductModel(
      id: id,
      name: map['name'] ?? map['title'] ?? 'Water Purifier',
      photoUrl: singlePhoto?.toString(),
      images: parsedImages,
      warrantyDetails: map['warranty'] ?? map['warrantyDetails'] ?? '1 Year Warranty',
      purchaseDate: map['createdAt'] != null
          ? map['createdAt'].toString()
          : (map['purchaseDate'] ?? 'Available'),
      isCustom: map['isCustom'] ?? false,
      price: rawPrice != null ? (rawPrice as num).toDouble() : 0.0,
      originalPrice: rawOrigPrice != null ? (rawOrigPrice as num).toDouble() : null,
      category: map['category'] ?? map['categoryId'],
      type: map['type'],
      rating: rawRating != null ? (rawRating as num).toDouble() : 4.8,
      reviewsCount: rawReviews != null ? (rawReviews as num).toInt() : 0,
      description: map['description'] ?? '',
      inStock: map['inStock'] ?? true,
      specSections: parsedSpecSections,
      features: parsedFeatures,
    );
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductModel.fromMap(data, doc.id);
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      images: entity.images,
      warrantyDetails: entity.warrantyDetails,
      purchaseDate: entity.purchaseDate,
      isCustom: entity.isCustom,
      price: entity.price,
      originalPrice: entity.originalPrice,
      category: entity.category,
      type: entity.type,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      description: entity.description,
      inStock: entity.inStock,
      specSections: entity.specSections,
      features: entity.features,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'imageUrl': photoUrl,
      'images': images,
      'warrantyDetails': warrantyDetails,
      'purchaseDate': purchaseDate,
      'isCustom': isCustom,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'type': type,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'description': description,
      'inStock': inStock,
      'specSections': specSections
          .map((sec) => {
                'title': sec.title,
                'items': sec.items
                    .map((it) => {
                          'label': it.label,
                          'value': it.value,
                        })
                    .toList(),
              })
          .toList(),
      'features': features,
    };
  }
}
