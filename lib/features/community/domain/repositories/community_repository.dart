import '../entities/review_entity.dart';
import '../entities/client_entity.dart';
import '../entities/faq_entity.dart';

abstract class CommunityRepository {
  Future<List<ReviewEntity>> getReviews();
  Future<List<ClientEntity>> getClients();
  Future<List<FaqEntity>> getFaqs();
  Future<void> submitReview({
    required String customerName,
    required String location,
    required double rating,
    required String comment,
  });
}
