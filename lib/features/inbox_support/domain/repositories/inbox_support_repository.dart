import '../entities/app_notification_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class InboxSupportRepository {
  Future<List<AppNotificationEntity>> getNotifications();
  Future<List<ChatMessageEntity>> getChatMessages();
  Future<void> submitSupportInquiry({
    required String fullName,
    required String phoneNumber,
    required String subject,
    required String message,
  });
  Future<String> getReferralCode();
}
