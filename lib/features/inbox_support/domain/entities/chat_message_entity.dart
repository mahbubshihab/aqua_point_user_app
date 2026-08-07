import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String senderName;
  final String message;
  final String time;
  final bool isFromUser;

  const ChatMessageEntity({
    required this.id,
    required this.senderName,
    required this.message,
    required this.time,
    this.isFromUser = false,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? senderName,
    String? message,
    String? time,
    bool? isFromUser,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      time: time ?? this.time,
      isFromUser: isFromUser ?? this.isFromUser,
    );
  }

  @override
  List<Object?> get props => [id, senderName, message, time, isFromUser];
}
