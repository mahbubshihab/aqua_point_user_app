import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/bulk_sms_service.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BulkSmsService bulkSmsService;
  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;

  AuthBloc({
    BulkSmsService? bulkSmsService,
    AuthLocalDatasource? localDatasource,
    AuthRemoteDatasource? remoteDatasource,
  })  : bulkSmsService = bulkSmsService ?? BulkSmsService(),
        localDatasource = localDatasource ?? AuthLocalDatasource(),
        remoteDatasource = remoteDatasource ?? AuthRemoteDatasource(),
        super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await localDatasource.isLoggedIn();
    if (isLoggedIn) {
      final phone = await localDatasource.getUserPhone() ?? '';
      final userId = await localDatasource.getUserId() ?? phone;
      emit(Authenticated(phoneNumber: phone, userId: userId));
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Generate 6-digit random OTP (100000 - 999999)
    final random = Random();
    final otpCode = (100000 + random.nextInt(900000)).toString();

    // Write/verify unique OTP document in Cloud Firestore otp_verifications collection
    await remoteDatasource.saveOtpVerification(
      phoneNumber: event.phoneNumber,
      otpCode: otpCode,
    );

    final response = await bulkSmsService.sendOtp(
      phoneNumber: event.phoneNumber,
      otpCode: otpCode,
    );

    String? apiMsg;
    if (response.isSuccess) {
      apiMsg = 'SMS sent successfully!';
    } else if (response.errorMessage.isNotEmpty) {
      apiMsg = '${response.errorMessage} (Test OTP: $otpCode)';
    } else {
      apiMsg = 'SMS delivery pending. (Test OTP: $otpCode)';
    }

    emit(OtpSentState(
      phoneNumber: event.phoneNumber,
      expectedOtp: otpCode,
      sentAt: DateTime.now(),
      apiMessage: apiMsg,
    ));
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final isVerified = await remoteDatasource.verifyOtp(
      phoneNumber: event.phoneNumber,
      inputOtp: event.inputOtp,
      expectedOtp: event.expectedOtp,
    );

    if (isVerified) {
      final userId = event.phoneNumber;

      // Persist session locally
      await localDatasource.saveSession(
        phone: event.phoneNumber,
        userId: userId,
      );

      // Create/update customer record in Firestore
      await remoteDatasource.saveOrUpdateCustomer(
        phone: event.phoneNumber,
        userId: userId,
      );

      emit(Authenticated(phoneNumber: event.phoneNumber, userId: userId));
    } else {
      emit(const AuthError(
        message: 'Incorrect or expired OTP entered. Please verify the code and try again.',
      ));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await localDatasource.clearSession();
    emit(const Unauthenticated());
  }
}
