import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

class InboxSupportMockDatasource {
  Future<List<AppNotificationEntity>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      AppNotificationEntity(
        id: 'notif-1',
        title: 'Filter Replacement Due',
        message: 'Your RO Water Purifier filter replacement is scheduled in 3 days.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AppNotificationEntity(
        id: 'notif-2',
        title: 'Water Quality Report',
        message: 'Monthly TDS reading update: 45 PPM (EXCELLENT).',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotificationEntity(
        id: 'notif-3',
        title: 'Reward Points Earned',
        message: 'You earned 50 reward points from your recent service completion.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }

  Future<List<ChatMessageEntity>> fetchChatMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const ChatMessageEntity(
        id: 'chat-1',
        senderName: 'AQUA POINT Support',
        message: 'Hello! How can we assist you with your water purifier today?',
        time: '10:30 AM',
        isFromUser: false,
      ),
      const ChatMessageEntity(
        id: 'chat-2',
        senderName: 'You',
        message: 'I would like to check my upcoming filter maintenance schedule.',
        time: '10:32 AM',
        isFromUser: true,
      ),
      const ChatMessageEntity(
        id: 'chat-3',
        senderName: 'AQUA POINT Support',
        message: 'Sure! Your next routine check is set for Aug 12, 2026.',
        time: '10:35 AM',
        isFromUser: false,
      ),
    ];
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
    return 'YVI3B4W';
  }
}
