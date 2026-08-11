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
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('reviews')
          .where('isApproved', isEqualTo: true)
          .limit(15)
          .get();
    } catch (_) {
      snapshot = await firestore
          .collection('reviews')
          .where('isApproved', isEqualTo: true)
          .get();
    }
    return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
  }

  @override
  Future<List<ClientModel>> getClients() async {
    final snapshot = await firestore.collection('clients').limit(15).get();
    return snapshot.docs.map((doc) => ClientModel.fromFirestore(doc)).toList();
  }

  @override
  Future<List<FaqModel>> getFaqs() async {
    final snapshot = await firestore.collection('faqs').limit(15).get();
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
