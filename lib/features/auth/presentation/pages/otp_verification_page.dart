import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/rain_and_waves_background.dart';
import '../../../home/presentation/pages/main_shell_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String? apiMessage;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    this.apiMessage,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

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
    _startResendTimer();

    if (widget.apiMessage != null && widget.apiMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.apiMessage!,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
            ),
            backgroundColor: const Color(0xFF00BCE1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      });
    }
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
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter 6-digit code'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          VerifyOtpEvent(
            phoneNumber: widget.phoneNumber,
            inputOtp: code,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorAccent = isDark ? const Color(0xFF00BCE1) : const Color(0xFF0088FF);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 54,
      textStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColorPrimary,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0A1628).withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColorAccent.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: textColorAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: textColorAccent.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: textColorAccent, width: 1.5),
        color: textColorAccent.withValues(alpha: 0.15),
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentState) {
          if (state.apiMessage != null && state.apiMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.apiMessage!,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                ),
                backgroundColor: textColorAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
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
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: RainAndWavesBackground(
          child: Stack(
            children: [
              // Top Action Buttons
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColorPrimary, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),

                    // Theme Toggle Button
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              themeProvider.toggleTheme();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0D1B2E).withValues(alpha: 0.8)
                                    : Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: textColorAccent.withValues(alpha: 0.4),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: textColorAccent.withValues(alpha: 0.2),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    themeProvider.isDarkMode
                                        ? Icons.wb_sunny_rounded
                                        : Icons.nightlight_round,
                                    color: themeProvider.isDarkMode
                                        ? const Color(0xFFFFB703)
                                        : const Color(0xFF0088FF),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    themeProvider.isDarkMode ? 'Light' : 'Dark',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: textColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Main Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Verify OTP',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColorPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a 6-digit code to',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: textColorPrimary.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: textColorAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: textColorAccent.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _formattedPhone,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textColorAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 6-Digit Pinput
                      Pinput(
                        length: 6,
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
                      const SizedBox(height: 32),

                      // Verify Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onVerifyPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: textColorAccent,
                                foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                                elevation: 10,
                                shadowColor: textColorAccent.withValues(alpha: 0.45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: isDark ? const Color(0xFF020810) : Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Verify Code',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Resend Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_timerSeconds > 0)
                            Text(
                              'Resend code in ${_timerSeconds}s',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColorPrimary.withValues(alpha: 0.65),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _onResendOtp,
                              child: Text(
                                'Resend Code',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColorAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
