import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

class InboxSupportRemoteDatasource {
  Future<List<AppNotificationEntity>> fetchNotifications() async {
    try {
      final userPhone = await AuthLocalDatasource().getUserPhone() ?? '';
      final userId = await AuthLocalDatasource().getUserId() ?? userPhone;

      final List<AppNotificationEntity> notifications = [];

      // 1. Fetch from notifications collection
      try {
        final notifSnap = await FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .limit(10)
            .get();

        for (final doc in notifSnap.docs) {
          final data = doc.data();
          notifications.add(AppNotificationEntity(
            id: doc.id,
            title: data['title'] ?? 'Notification',
            message: data['message'] ?? '',
            timestamp: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            isRead: data['isRead'] ?? false,
          ));
        }
      } catch (_) {}

      // 2. Also generate dynamic notifications from user's service_requests if empty
      if (notifications.isEmpty && userId.isNotEmpty) {
        try {
          final serviceSnap = await FirebaseFirestore.instance
              .collection('service_requests')
              .where('userId', isEqualTo: userId)
              .limit(10)
              .get();

          for (final doc in serviceSnap.docs) {
            final data = doc.data();
            final reqId = data['serviceId'] ?? data['requestId'] ?? doc.id;
            final status = data['status'] ?? 'Pending';
            notifications.add(AppNotificationEntity(
              id: 'NOTIF-${doc.id}',
              title: 'Service Request #$reqId',
              message: 'Your service request status is currently: $status',
              timestamp: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              isRead: status == 'Completed',
            ));
          }
        } catch (_) {}
      }

      return notifications;
    } catch (_) {
      return [];
    }
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
