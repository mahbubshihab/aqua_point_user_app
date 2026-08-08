import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

class InboxSupportRemoteDatasource {
  Future<List<AppNotificationEntity>> fetchNotifications() async {
    return [];
  }

  Future<List<ChatMessageEntity>> fetchChatMessages() async {
    return [];
  }

  Future<void> submitInquiry({
    required String fullName,
    required String phoneNumber,
    required String subject,
    required String message,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('inquiries').add({
        'name': fullName,
        'phone': phoneNumber,
        'subject': subject,
        'message': message,
        'status': 'New',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignored
    }
  }
}
