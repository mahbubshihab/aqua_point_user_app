import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';
import '../models/client_model.dart';
import '../models/faq_model.dart';

abstract class CommunityRemoteDatasource {
  Future<List<ReviewModel>> getReviews();
  Future<List<ClientModel>> getClients();
  Future<List<FaqModel>> getFaqs();
  Future<void> submitReview({
    required String customerName,
    required String location,
    required double rating,
    required String comment,
  });
}

class CommunityRemoteDatasourceImpl implements CommunityRemoteDatasource {
  final FirebaseFirestore firestore;

  CommunityRemoteDatasourceImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ReviewModel>> getReviews() async {
    final snapshot = await firestore.collection('reviews').get();
    return snapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc))
        .where((r) => r.isApproved)
        .toList();
  }

  @override
  Future<List<ClientModel>> getClients() async {
    final snapshot = await firestore.collection('clients').get();
    return snapshot.docs.map((doc) => ClientModel.fromFirestore(doc)).toList();
  }

  @override
  Future<List<FaqModel>> getFaqs() async {
    final snapshot = await firestore.collection('faqs').get();
    return snapshot.docs.map((doc) => FaqModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> submitReview({
    required String customerName,
    required String location,
    required double rating,
    required String comment,
  }) async {
    await firestore.collection('reviews').add({
      'customerName': customerName,
      'location': location,
      'rating': rating,
      'comment': comment,
      'isApproved': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
