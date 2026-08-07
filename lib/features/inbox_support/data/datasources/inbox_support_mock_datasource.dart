import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

class InboxSupportMockDatasource {
  Future<List<AppNotificationEntity>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<List<ChatMessageEntity>> fetchChatMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  Future<void> submitInquiry({
    required String fullName,
    required String phoneNumber,
    required String subject,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<String> fetchReferralCode() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return '';
  }
}
