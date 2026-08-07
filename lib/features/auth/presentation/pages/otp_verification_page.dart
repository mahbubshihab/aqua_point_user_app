import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../home/presentation/pages/main_shell_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String expectedOtp;
  final String? apiMessage;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.expectedOtp,
    this.apiMessage,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  late String _currentExpectedOtp;
  late int _timerSeconds;
  Timer? _timer;

  String get _formattedPhone {
    final phone = widget.phoneNumber.trim();
    if (phone.startsWith('0')) {
      return '+88$phone';
    } else if (phone.startsWith('+880')) {
      return phone;
    } else if (phone.startsWith('880')) {
      return '+$phone';
    }
    return '+880$phone';
  }

  @override
  void initState() {
    super.initState();
    _currentExpectedOtp = widget.expectedOtp;
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _timerSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    final code = _pinController.text.trim();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter 4-digit code'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          VerifyOtpEvent(
            phoneNumber: widget.phoneNumber,
            inputOtp: code,
            expectedOtp: _currentExpectedOtp,
          ),
        );
  }

  void _onResendOtp() {
    if (_timerSeconds > 0) return;
    _pinController.clear();
    context.read<AuthBloc>().add(SendOtpEvent(phoneNumber: widget.phoneNumber));
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF00E5FF), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentState) {
          setState(() {
            _currentExpectedOtp = state.expectedOtp;
          });
        } else if (state is Authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainShellPage()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.accentRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            // Background cyan glow
            Positioned(
              top: -40,
              left: -50,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 120,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      // Header: Verify OTP Title
                      Text(
                        'Verify OTP',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Phone Number Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.phone_android_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formattedPhone,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (widget.apiMessage != null && widget.apiMessage!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            widget.apiMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // Glassmorphic OTP Card
                      GlassCard(
                        borderRadius: 24.0,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
                        fillColor: const Color(0x281E293B),
                        borderColor: AppColors.divider,
                        child: Column(
                          children: [
                            // 4-Digit Glassmorphic Pinput
                            Pinput(
                              length: 4,
                              controller: _pinController,
                              focusNode: _pinFocusNode,
                              autofocus: true,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              onCompleted: (pin) {
                                _onVerifyPressed();
                              },
                            ),
                            const SizedBox(height: 28),

                            // Primary Button Verify with Cyan Gradient & Glow
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;

                                return Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF00E5FF),
                                        Color(0xFF0090B8),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: isLoading ? null : _onVerifyPressed,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Center(
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Text(
                                                'Verify',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Minimal Resend Timer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_timerSeconds > 0)
                                  Text(
                                    'Resend in ${_timerSeconds}s',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: _onResendOtp,
                                    child: Text(
                                      'Resend Code',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00E5FF),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

