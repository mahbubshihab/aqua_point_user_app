import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/faq_entity.dart';

class FaqModel extends FaqEntity {
  const FaqModel({
    required super.id,
    required super.question,
    required super.answer,
    super.category,
    super.createdAt,
  });

  factory FaqModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime? created;
    if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
      created = (data['createdAt'] as Timestamp).toDate();
    }
    return FaqModel(
      id: doc.id,
      question: data['question'] as String? ?? '',
      answer: data['answer'] as String? ?? '',
      category: data['category'] as String?,
      createdAt: created,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'question': question,
      'answer': answer,
      if (category != null) 'category': category,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
