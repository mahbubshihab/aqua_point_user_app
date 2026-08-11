import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/bulk_sms_service.dart';
import '../../../../core/widgets/rain_and_waves_background.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _phoneError;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    final rawPhone = _phoneController.text.trim();
    if (rawPhone.isEmpty) {
      setState(() {
        _phoneError = 'Please enter phone number';
      });
      return;
    }

    final clean = sanitizePhone(rawPhone);

    if (clean.length != 11 || !clean.startsWith('01')) {
      setState(() {
        _phoneError = 'Enter valid 11-digit number (e.g. 01780885841)';
      });
      return;
    }

    setState(() {
      _phoneError = null;
    });

    context.read<AuthBloc>().add(SendOtpEvent(phoneNumber: clean));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationPage(
                phoneNumber: state.phoneNumber,
                apiMessage: state.apiMessage,
              ),
            ),
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
        backgroundColor: const Color(0xFF020810),
        body: RainAndWavesBackground(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Container(
                width: double.infinity,
                maxWidth: 380,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                decoration: BoxDecoration(
                  color: const Color(0xFF081223).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFF00BCE1).withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 50,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: const Color(0xFF00BCE1).withValues(alpha: 0.1),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Glowing Cyan Border Line
                      Container(
                        width: 80,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BCE1),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF00BCE1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Logo Icon
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.0 + (_pulseController.value * 0.08),
                                child: Container(
                                  width: 84,
                                  height: 84,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF00BCE1).withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0A1628), Color(0xFF0D2035)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFF00BCE1).withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00BCE1).withValues(alpha: 0.25),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/app_logo.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(
                                      Icons.water_drop_rounded,
                                      size: 36,
                                      color: Color(0xFF00BCE1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Brand Title: AQUA POINT
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'AQUA ',
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3.0,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'POINT',
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3.0,
                                color: const Color(0xFF00BCE1),
                                shadows: [
                                  const Shadow(
                                    color: Color(0x9900BCE1),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Phone Input Container
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1B2E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _phoneError != null
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF00BCE1).withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Country Code Prefix
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: const Color(0xFF00BCE1).withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🇧🇩', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '+880',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Number Input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                                decoration: InputDecoration(
                                  hintText: '1XXXXXXXXX',
                                  hintStyle: GoogleFonts.inter(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                ),
                                onChanged: (_) {
                                  if (_phoneError != null) {
                                    setState(() {
                                      _phoneError = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_phoneError != null) ...[
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _phoneError!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Send OTP Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onSendOtpPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00BCE1),
                                foregroundColor: const Color(0xFF020810),
                                elevation: 8,
                                shadowColor: const Color(0xFF00BCE1).withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF020810),
                                      ),
                                    )
                                  : Text(
                                      'Send OTP',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // "Continue with Google" Button (Matching Admin Web screenshot!)
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF00BCE1).withValues(alpha: 0.12),
                              const Color(0xFF3E4396).withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: const Color(0xFF00BCE1).withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              // Fast guest login / Google sign-in demo trigger
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Google Sign-In ready! Use Phone OTP to sign in.',
                                    style: GoogleFonts.inter(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF00BCE1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google Logo G
                                Image.network(
                                  'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                  width: 20,
                                  height: 20,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.g_mobiledata_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Continue with Google',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
