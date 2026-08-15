import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../home/presentation/pages/main_shell_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_wave_background.dart';

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
    String clean = widget.phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('880')) {
      clean = clean.substring(3);
    }
    if (clean.startsWith('0')) {
      clean = clean.substring(1);
    }
    return '+880 $clean';
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
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
            ),
            backgroundColor: const Color(0xFF00B4D8),
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
        SnackBar(
          content: Text(
            'Please enter the full 6-digit verification code',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
          ),
          backgroundColor: const Color(0xFFFF4D4F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
    // 6-Digit Pin Input Theme matching login.html styling
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 52,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0077B6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 2,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00B4D8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B4D8).withValues(alpha: 0.3),
            blurRadius: 15,
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(
          color: const Color(0xFF00B4D8),
          width: 2,
        ),
        color: const Color(0xFFF0F8FF),
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
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                ),
                backgroundColor: const Color(0xFF00B4D8),
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
              content: Text(
                state.message,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              ),
              backgroundColor: const Color(0xFFFF4D4F),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: AuthWaveBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Back Button (Top Left)
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Main Content
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 20),
                            child: Text(
                              'Verification',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),

                          // Form Card Section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 36),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 30,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated Bouncing Water Drop
                                  const Center(
                                    child: _AnimatedWaterDrop(),
                                  ),
                                  const SizedBox(height: 16),

                                  // Title: Enter OTP
                                  Text(
                                    'Enter OTP',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2B2B2B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Subtitle with formatted phone
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF7A7A7A),
                                        height: 1.5,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'A verification code has been sent to \n',
                                        ),
                                        TextSpan(
                                          text: _formattedPhone,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0077B6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // 6-Digit OTP Container
                                  Center(
                                    child: Pinput(
                                      length: 6,
                                      controller: _pinController,
                                      focusNode: _pinFocusNode,
                                      autofocus: true,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      autofillHints: const [AutofillHints.oneTimeCode],
                                      defaultPinTheme: defaultPinTheme,
                                      focusedPinTheme: focusedPinTheme,
                                      submittedPinTheme: submittedPinTheme,
                                      onCompleted: (_) => _onVerifyPressed(),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Verify Button
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      final isLoading = state is AuthLoading;

                                      return Container(
                                        height: 52,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF0077B6),
                                              Color(0xFF00B4D8),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF0077B6).withValues(alpha: 0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(12),
                                            onTap: isLoading ? null : _onVerifyPressed,
                                            child: Center(
                                              child: isLoading
                                                  ? const SizedBox(
                                                      width: 22,
                                                      height: 22,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Verify',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Timer Text & Resend Button
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: "Didn't receive the code? ",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color(0xFF7A7A7A),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '00:${_timerSeconds.toString().padLeft(2, '0')}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF7A7A7A),
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      GestureDetector(
                                        onTap: _timerSeconds == 0 ? _onResendOtp : null,
                                        child: Text(
                                          'Resend OTP',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _timerSeconds == 0
                                                ? const Color(0xFF0077B6)
                                                : const Color(0xFF0077B6).withValues(alpha: 0.4),
                                            decoration: _timerSeconds == 0
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated water droplet bounce matching CSS dropBounce animation
class _AnimatedWaterDrop extends StatefulWidget {
  const _AnimatedWaterDrop();

  @override
  State<_AnimatedWaterDrop> createState() => _AnimatedWaterDropState();
}

class _AnimatedWaterDropState extends State<_AnimatedWaterDrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Sine wave for smooth 2s bounce
        final progress = _controller.value;
        final sinVal = math.sin(progress * 2 * math.pi);
        final offsetY = sinVal < 0 ? sinVal * 10 : 0.0;
        final scale = 1.0 + (sinVal < 0 ? -sinVal * 0.1 : 0.0);

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: -math.pi / 4, // -45 deg
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF00B4D8), // Secondary Cyan
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.zero,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
