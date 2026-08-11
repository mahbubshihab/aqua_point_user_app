import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/rain_and_waves_background.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/main_shell_page.dart';

class CustomSplashPage extends StatefulWidget {
  const CustomSplashPage({super.key});

  @override
  State<CustomSplashPage> createState() => _CustomSplashPageState();
}

class _CustomSplashPageState extends State<CustomSplashPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _dotsController;

  late Animation<double> _cardScale;
  late Animation<double> _cardFade;
  late Animation<double> _pulseAnimation;

  bool _navigated = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _cardFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _cardScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _mainController.forward();

    _fallbackTimer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted || _navigated) return;
      final currentState = context.read<AuthBloc>().state;
      if (currentState is Authenticated) {
        _navigateToPage(const MainShellPage());
      } else {
        _navigateToPage(const LoginPage());
      }
    });
  }

  void _navigateToPage(Widget targetPage) {
    if (_navigated || !mounted) return;
    _navigated = true;
    _fallbackTimer?.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _mainController.dispose();
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Future.delayed(const Duration(milliseconds: 800), () {
            _navigateToPage(const MainShellPage());
          });
        } else if (state is Unauthenticated) {
          Future.delayed(const Duration(milliseconds: 800), () {
            _navigateToPage(const LoginPage());
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF020810),
        body: RainAndWavesBackground(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _cardFade.value,
                    child: Transform.scale(
                      scale: _cardScale.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  maxWidth: 360,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFF081223).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFF00BCE1).withValues(alpha: 0.25),
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
                      const SizedBox(height: 32),

                      // Pulsing Logo Icon
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF00BCE1).withValues(alpha: 0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 76,
                                height: 76,
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
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(
                                      Icons.water_drop_rounded,
                                      size: 40,
                                      color: Color(0xFF00BCE1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 28),

                      // Brand Title: AQUA POINT
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'AQUA ',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3.0,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'POINT',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
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
                      const SizedBox(height: 8),

                      Text(
                        'Pure Water, Better Life',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Animated Dots
                      _buildAnimatedDots(),
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

  Widget _buildAnimatedDots() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            double scale = 1.0;

            double normalizedTime = (_dotsController.value - delay) % 1.0;
            if (normalizedTime < 0) normalizedTime += 1.0;

            if (normalizedTime < 0.4) {
              scale = 1.0 + math.sin(normalizedTime * math.pi / 0.4) * 0.5;
            }

            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00BCE1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
