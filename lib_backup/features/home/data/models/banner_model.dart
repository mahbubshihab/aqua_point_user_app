import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.title,
    super.subtitle,
    super.tag,
    required super.imageUrl,
    super.ctaLink,
    required super.isActive,
    super.position,
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BannerModel(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Banner',
      subtitle: (data['subtitle'] ?? data['description']) as String?,
      tag: (data['tag'] ?? data['badge']) as String?,
      imageUrl: (data['imageUrl'] ?? data['image']) as String? ?? '',
      ctaLink: (data['ctaLink'] ?? data['link'] ?? data['cta']) as String?,
      isActive: data['isActive'] != null ? data['isActive'] as bool : true,
      position: (data['position'] ?? data['type'] ?? data['category']) as String?,
    );
  }

  factory BannerModel.fromMap(Map<String, dynamic> map, String id) {
    return BannerModel(
      id: id,
      title: map['title'] as String? ?? 'Untitled Banner',
      subtitle: (map['subtitle'] ?? map['description']) as String?,
      tag: (map['tag'] ?? map['badge']) as String?,
      imageUrl: (map['imageUrl'] ?? map['image']) as String? ?? '',
      ctaLink: (map['ctaLink'] ?? map['link'] ?? map['cta']) as String?,
      isActive: map['isActive'] != null ? map['isActive'] as bool : true,
      position: (map['position'] ?? map['type'] ?? map['category']) as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      'tag': tag,
      'imageUrl': imageUrl,
      'ctaLink': ctaLink,
      'isActive': isActive,
      if (position != null) 'position': position,
    };
  }
}
