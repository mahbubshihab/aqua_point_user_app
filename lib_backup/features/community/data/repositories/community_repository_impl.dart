import '../../domain/entities/review_entity.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/entities/faq_entity.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDatasource remoteDatasource;

  CommunityRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ReviewEntity>> getReviews() async {
    return await remoteDatasource.getReviews();
  }

  @override
  Future<List<ClientEntity>> getClients() async {
    return await remoteDatasource.getClients();
  }

  @override
  Future<List<FaqEntity>> getFaqs() async {
    return await remoteDatasource.getFaqs();
  }

  @override
  Future<void> submitReview({
    required String customerName,
    required String location,
    required double rating,
    required String comment,
  }) async {
    await remoteDatasource.submitReview(
      customerName: customerName,
      location: location,
      rating: rating,
      comment: comment,
    );
  }
}
