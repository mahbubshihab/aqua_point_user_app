import 'package:equatable/equatable.dart';

abstract class InboxSupportEvent extends Equatable {
  const InboxSupportEvent();

  @override
  List<Object?> get props => [];
}

class LoadInboxData extends InboxSupportEvent {
  const LoadInboxData();
}

class SelectInboxTab extends InboxSupportEvent {
  final int index;

  const SelectInboxTab(this.index);

  @override
  List<Object?> get props => [index];
}

class SubmitSupportInquiry extends InboxSupportEvent {
  final String fullName;
  final String phoneNumber;
  final String subject;
  final String message;

  const SubmitSupportInquiry({
    required this.fullName,
    required this.phoneNumber,
    required this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber, subject, message];
}

class CopyReferralCode extends InboxSupportEvent {
  const CopyReferralCode();
}
