import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String customerName;
  final String location;
  final double rating;
  final String comment;
  final bool isApproved;
  final DateTime? createdAt;

  const ReviewEntity({
    required this.id,
    required this.customerName,
    required this.location,
    required this.rating,
    required this.comment,
    required this.isApproved,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, customerName, location, rating, comment, isApproved, createdAt];
}
