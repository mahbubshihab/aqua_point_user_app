import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated wave background widget matching the reference login.html design.
/// Features a gradient top wave (35-40% screen height) with rotating translucent
/// ambient squircle shapes and a clean light (#F0F8FF) lower canvas.
class AuthWaveBackground extends StatefulWidget {
  final Widget child;

  const AuthWaveBackground({
    super.key,
    required this.child,
  });

  @override
  State<AuthWaveBackground> createState() => _AuthWaveBackgroundState();
}

class _AuthWaveBackgroundState extends State<AuthWaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    // 30 seconds common multiple for 10s and 15s rotations
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final waveHeight = (size.height * 0.38).clamp(240.0, 360.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: Stack(
        children: [
          // Fixed Wave Header at Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: waveHeight,
            child: ClipPath(
              clipper: _WaveHeaderClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF00B4D8), // Secondary cyan
                      Color(0xFF0077B6), // Primary ocean blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _spinController,
                  builder: (context, _) {
                    final angle10s = _spinController.value * 2 * math.pi * 3;
                    final angle15s = _spinController.value * 2 * math.pi * 2;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Translucent rotating shape 2 (::before)
                        Positioned(
                          top: -280,
                          left: -80,
                          child: Transform.rotate(
                            angle: angle15s,
                            child: Container(
                              width: 500,
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                          ),
                        ),

                        // Translucent rotating shape 1 (::after)
                        Positioned(
                          top: -300,
                          left: -50,
                          child: Transform.rotate(
                            angle: angle10s,
                            child: Container(
                              width: 500,
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Main Foreground Content
          Positioned.fill(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Creates a smooth curved bottom edge matching CSS border-bottom-left/right-radius 50%
class _WaveHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);

    // Smooth quadratic curve extending downward in the center
    final controlPoint = Offset(size.width / 2, size.height + 25);
    final endPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
