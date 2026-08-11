import 'package:equatable/equatable.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/entities/faq_entity.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {
  const CommunityInitial();
}

class CommunityLoading extends CommunityState {
  const CommunityLoading();
}

class CommunityLoaded extends CommunityState {
  final List<ReviewEntity> reviews;
  final List<ClientEntity> clients;
  final List<FaqEntity> faqs;

  const CommunityLoaded({
    required this.reviews,
    required this.clients,
    required this.faqs,
  });

  @override
  List<Object?> get props => [reviews, clients, faqs];
}

class CommunityError extends CommunityState {
  final String message;

  const CommunityError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewSubmittedSuccess extends CommunityState {
  const ReviewSubmittedSuccess();
}
