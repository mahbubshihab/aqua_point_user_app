import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String? tag;
  final String imageUrl;
  final String? ctaLink;
  final bool isActive;
  final String? position;

  const BannerEntity({
    required this.id,
    required this.title,
    this.subtitle,
    this.tag,
    required this.imageUrl,
    this.ctaLink,
    required this.isActive,
    this.position,
  });

  @override
  List<Object?> get props => [id, title, subtitle, tag, imageUrl, ctaLink, isActive, position];
}

