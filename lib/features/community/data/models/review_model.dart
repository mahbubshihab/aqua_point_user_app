import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.customerName,
    required super.location,
    required super.rating,
    required super.comment,
    required super.isApproved,
    super.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime? created;
    if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
      created = (data['createdAt'] as Timestamp).toDate();
    }
    return ReviewModel(
      id: doc.id,
      customerName: data['customerName'] as String? ?? data['name'] as String? ?? 'Customer',
      location: data['location'] as String? ?? 'Dhaka',
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      comment: data['comment'] as String? ?? '',
      isApproved: data['isApproved'] as bool? ?? data['approved'] as bool? ?? true,
      createdAt: created,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerName': customerName,
      'location': location,
      'rating': rating,
      'comment': comment,
      'isApproved': isApproved,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
