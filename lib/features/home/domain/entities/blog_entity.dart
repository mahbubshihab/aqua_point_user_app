import 'package:equatable/equatable.dart';

class BlogEntity extends Equatable {
  final String id;
  final String title;
  final String date;
  final String imageUrl;

  const BlogEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, date, imageUrl];
}
