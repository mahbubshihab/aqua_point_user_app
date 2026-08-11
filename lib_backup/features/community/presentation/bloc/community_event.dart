import 'package:equatable/equatable.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object?> get props => [];
}

class LoadCommunityData extends CommunityEvent {
  const LoadCommunityData();
}

class SubmitCustomerReview extends CommunityEvent {
  final String customerName;
  final String location;
  final double rating;
  final String comment;

  const SubmitCustomerReview({
    required this.customerName,
    required this.location,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [customerName, location, rating, comment];
}
