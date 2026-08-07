import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.title,
    super.tag,
    required super.imageUrl,
    super.ctaLink,
    required super.isActive,
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BannerModel(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Banner',
      tag: (data['tag'] ?? data['badge']) as String?,
      imageUrl: (data['imageUrl'] ?? data['image']) as String? ?? '',
      ctaLink: (data['ctaLink'] ?? data['link']) as String?,
      isActive: data['isActive'] != null ? data['isActive'] as bool : true,
    );
  }

  factory BannerModel.fromMap(Map<String, dynamic> map, String id) {
    return BannerModel(
      id: id,
      title: map['title'] as String? ?? 'Untitled Banner',
      tag: (map['tag'] ?? map['badge']) as String?,
      imageUrl: (map['imageUrl'] ?? map['image']) as String? ?? '',
      ctaLink: (map['ctaLink'] ?? map['link']) as String?,
      isActive: map['isActive'] != null ? map['isActive'] as bool : true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'tag': tag,
      'imageUrl': imageUrl,
      'ctaLink': ctaLink,
      'isActive': isActive,
    };
  }
}
