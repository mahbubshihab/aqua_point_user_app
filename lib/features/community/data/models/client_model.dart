import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    required super.industry,
    required super.logoUrl,
    super.createdAt,
  });

  factory ClientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime? created;
    if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
      created = (data['createdAt'] as Timestamp).toDate();
    }
    return ClientModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Corporate Client',
      industry: data['industry'] as String? ?? 'Corporate',
      logoUrl: data['logoUrl'] as String? ?? data['imageUrl'] as String? ?? '',
      createdAt: created,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'industry': industry,
      'logoUrl': logoUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
