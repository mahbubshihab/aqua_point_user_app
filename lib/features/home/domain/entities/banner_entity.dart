import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String? tag;
  final String imageUrl;
  final String? ctaLink;
  final bool isActive;

  const BannerEntity({
    required this.id,
    required this.title,
    this.tag,
    required this.imageUrl,
    this.ctaLink,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, title, tag, imageUrl, ctaLink, isActive];
}
