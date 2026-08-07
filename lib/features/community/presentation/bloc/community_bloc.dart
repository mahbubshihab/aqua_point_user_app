import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityRepository repository;

  CommunityBloc({required this.repository}) : super(const CommunityInitial()) {
    on<LoadCommunityData>(_onLoadCommunityData);
    on<SubmitCustomerReview>(_onSubmitCustomerReview);
  }

  Future<void> _onLoadCommunityData(
    LoadCommunityData event,
    Emitter<CommunityState> emit,
  ) async {
    emit(const CommunityLoading());
    try {
      final reviewsResults = await repository.getReviews();
      final clientsResults = await repository.getClients();
      final faqsResults = await repository.getFaqs();

      emit(CommunityLoaded(
        reviews: reviewsResults,
        clients: clientsResults,
        faqs: faqsResults,
      ));
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> _onSubmitCustomerReview(
    SubmitCustomerReview event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await repository.submitReview(
        customerName: event.customerName,
        location: event.location,
        rating: event.rating,
        comment: event.comment,
      );
      emit(const ReviewSubmittedSuccess());
      add(const LoadCommunityData());
    } catch (e) {
      emit(CommunityError(e.toString()));
    }
  }
}
