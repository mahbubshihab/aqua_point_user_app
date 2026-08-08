import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class OtpSentState extends AuthState {
  final String phoneNumber;
  final DateTime sentAt;
  final String? apiMessage;

  const OtpSentState({
    required this.phoneNumber,
    required this.sentAt,
    this.apiMessage,
  });

  @override
  List<Object?> get props => [phoneNumber, sentAt, apiMessage];
}

class Authenticated extends AuthState {
  final String phoneNumber;
  final String userId;

  const Authenticated({
    required this.phoneNumber,
    required this.userId,
  });

  @override
  List<Object?> get props => [phoneNumber, userId];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
