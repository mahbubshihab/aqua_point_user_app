import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String id;
  final String title;
  final String date;
  final String imageUrl;
  final String? category;
  final String? readTime;
  final String? content;

  const BlogEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
    this.category,
    this.readTime,
    this.content,
  });

  @override
  List<Object?> get props => [id, title, date, imageUrl, category, readTime, content];
}
