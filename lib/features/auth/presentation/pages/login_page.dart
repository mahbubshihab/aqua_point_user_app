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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorAccent = isDark ? const Color(0xFF00BCE1) : const Color(0xFF0088FF);

    final inputBg = isDark
        ? const Color(0xFF0A1628).withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.85);

    final inputBorder = isDark
        ? const Color(0xFF00BCE1).withValues(alpha: 0.35)
        : const Color(0xFF0088FF).withValues(alpha: 0.35);

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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: RainAndWavesBackground(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Icon with Pulsing Cyan Ring
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.08),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: textColorAccent.withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: isDark
                                    ? const LinearGradient(
                                        colors: [Color(0xFF0A1628), Color(0xFF0D2035)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : const LinearGradient(
                                        colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                border: Border.all(
                                  color: textColorAccent.withValues(alpha: 0.45),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: textColorAccent.withValues(alpha: 0.3),
                                    blurRadius: 24,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.water_drop_rounded,
                                    size: 38,
                                    color: textColorAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Brand Title: AQUA POINT
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'AQUA ',
                            style: GoogleFonts.outfit(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.5,
                              color: textColorPrimary,
                            ),
                          ),
                          TextSpan(
                            text: 'POINT',
                            style: GoogleFonts.outfit(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.5,
                              color: textColorAccent,
                              shadows: [
                                Shadow(
                                  color: textColorAccent.withValues(alpha: 0.6),
                                  blurRadius: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Pure Water, Better Life',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        color: textColorPrimary.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Phone Input Container (Floating directly on body)
                    Container(
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _phoneError != null
                              ? const Color(0xFFEF4444)
                              : inputBorder,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Country Code Prefix
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: inputBorder,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇧🇩', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(
                                  '+880',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textColorPrimary,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColorPrimary,
                                letterSpacing: 1.0,
                              ),
                              decoration: InputDecoration(
                                hintText: '1XXXXXXXXX',
                                hintStyle: GoogleFonts.inter(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.35)
                                      : const Color(0xFF94A3B8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _phoneError!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFEF4444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Send OTP Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _onSendOtpPressed,
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
                                    'Send OTP',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
