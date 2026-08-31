import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/bulk_sms_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_wave_background.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  String? _phoneError;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _phoneFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    final rawPhone = _phoneController.text.trim();
    if (rawPhone.isEmpty) {
      setState(() {
        _phoneError = 'Please enter your mobile number';
      });
      return;
    }

    final clean = sanitizePhone(rawPhone);

    if (clean.length != 11 || !clean.startsWith('01')) {
      setState(() {
        _phoneError = 'Please enter a valid 10-digit number (e.g. 1XXXXXXXXX)';
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Section
                      Padding(
                        padding: const EdgeInsets.only(top: 28, bottom: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aqua Point BD',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pure Water, Pure Life',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
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
                              // Title
                              Text(
                                'Welcome!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2B2B2B),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Subtitle
                              Text(
                                'Enter your mobile number to continue',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF7A7A7A),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Input Group
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  color: _isFocused ? Colors.white : const Color(0xFFF0F8FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _phoneError != null
                                        ? const Color(0xFFFF4D4F)
                                        : (_isFocused
                                            ? const Color(0xFF00B4D8)
                                            : const Color(0xFFE2E8F0)),
                                    width: 1.5,
                                  ),
                                  boxShadow: _isFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF00B4D8).withValues(alpha: 0.2),
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : null,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    // Country Code
                                    Text(
                                      '+880',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0077B6),
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 24,
                                      color: const Color(0xFFCBD5E1),
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                    ),

                                    // Phone Input Field
                                    Expanded(
                                      child: TextField(
                                        controller: _phoneController,
                                        focusNode: _phoneFocusNode,
                                        cursorColor: const Color(0xFF0077B6),
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2B2B2B),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: '1XXXXXXXXX',
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF9E9E9E),
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onChanged: (_) {
                                          if (_phoneError != null) {
                                            setState(() {
                                              _phoneError = null;
                                            });
                                          }
                                        },
                                        onSubmitted: (_) => _onSendOtpPressed(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Validation Error Text
                              if (_phoneError != null) ...[
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    _phoneError!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFFFF4D4F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 20),

                              // Login Button with Gradient & Ripple Effect
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
                                        onTap: isLoading ? null : _onSendOtpPressed,
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
                                                  'Login',
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
        ),
      ),
    );
  }
}
