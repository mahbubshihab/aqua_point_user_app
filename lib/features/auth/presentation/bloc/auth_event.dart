import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String inputOtp;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.inputOtp,
  });

  @override
  List<Object?> get props => [phoneNumber, inputOtp];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
