import 'package:equatable/equatable.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

abstract class InboxSupportState extends Equatable {
  const InboxSupportState();

  @override
  List<Object?> get props => [];
}

class InboxSupportInitial extends InboxSupportState {
  const InboxSupportInitial();
}

class InboxSupportLoading extends InboxSupportState {
  const InboxSupportLoading();
}

class InboxSupportLoaded extends InboxSupportState {
  final int selectedTabIndex;
  final List<AppNotificationEntity> notifications;
  final List<ChatMessageEntity> chatMessages;


  const InboxSupportLoaded({
    this.selectedTabIndex = 0,
    required this.notifications,
    required this.chatMessages,
  });

  InboxSupportLoaded copyWith({
    int? selectedTabIndex,
    List<AppNotificationEntity>? notifications,
    List<ChatMessageEntity>? chatMessages,
  }) {
    return InboxSupportLoaded(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      notifications: notifications ?? this.notifications,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }

  @override
  List<Object?> get props => [
        selectedTabIndex,
        notifications,
        chatMessages,
      ];
}

class InquirySubmitting extends InboxSupportState {
  const InquirySubmitting();
}

class InquirySubmittedSuccess extends InboxSupportState {
  final String message;

  const InquirySubmittedSuccess({this.message = 'Inquiry sent successfully!'});

  @override
  List<Object?> get props => [message];
}

class InboxSupportError extends InboxSupportState {
  final String message;

  const InboxSupportError(this.message);

  @override
  List<Object?> get props => [message];
}
