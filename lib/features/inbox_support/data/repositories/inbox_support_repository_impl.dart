import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/inbox_support_repository.dart';
import '../datasources/inbox_support_mock_datasource.dart';

class InboxSupportRepositoryImpl implements InboxSupportRepository {
  final InboxSupportMockDatasource datasource;

  InboxSupportRepositoryImpl({required this.datasource});

  @override
  Future<List<AppNotificationEntity>> getNotifications() async {
    return await datasource.fetchNotifications();
  }

  @override
  Future<List<ChatMessageEntity>> getChatMessages() async {
    return await datasource.fetchChatMessages();
  }

  @override
  Future<void> submitSupportInquiry({
    required String fullName,
    required String phoneNumber,
    required String subject,
    required String message,
  }) async {
    return await datasource.submitInquiry(
      fullName: fullName,
      phoneNumber: phoneNumber,
      subject: subject,
      message: message,
    );
  }

  @override
  Future<String> getReferralCode() async {
    return await datasource.fetchReferralCode();
  }
}
