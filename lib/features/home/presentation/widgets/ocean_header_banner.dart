import 'dart:math' as math;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OceanHeaderBanner extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const OceanHeaderBanner({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  State<OceanHeaderBanner> createState() => _OceanHeaderBannerState();
}

class _OceanHeaderBannerState extends State<OceanHeaderBanner>
    with TickerProviderStateMixin {
  late final AnimationController _bubbleController;
  late final AnimationController _bellController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _bellController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else if (hour >= 17 || hour < 5) {
      return 'Good Evening,';
    } else {
      return 'Good Morning,';
    }
  }

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
        return user.displayName!.trim();
      }
      if (user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty) {
        return user.phoneNumber!.trim();
      }
    }
    return 'Customer';
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final greeting = _getGreeting();
    final userName = _getUserName();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Color(0x330083B0),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
        child: Stack(
          children: [
            // Ambient Floating Bubbles
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _AmbientBubblesPainter(
                      progress: _bubbleController.value,
                    ),
                  );
                },
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.only(
                top: topPadding + 14,
                left: 20,
                right: 20,
                bottom: 58,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Navigation Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu Button
                      _GlassIconButton(
                        icon: Icons.notes_rounded,
                        onTap: widget.onMenuTap ?? widget.onProfileTap,
                      ),

                      // Brand Title
                      Text(
                        'Aqua Point',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),

                      // Notification Bell with Badge
                      _AnimatedBellButton(
                        controller: _bellController,
                        onTap: widget.onNotificationTap,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Greeting Section
                  Text(
                    greeting,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFDBEAFE),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Hello, $userName 👋',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _GlassIconButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.white.withValues(alpha: 0.20),
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withValues(alpha: 0.25),
            highlightColor: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedBellButton extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback? onTap;

  const _AnimatedBellButton({
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Material(
              color: Colors.white.withValues(alpha: 0.20),
              child: InkWell(
                onTap: onTap,
                splashColor: Colors.white.withValues(alpha: 0.25),
                highlightColor: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      final val = controller.value;
                      double angle = 0.0;
                      if (val < 0.10) {
                        angle = (val / 0.10) * (20 * math.pi / 180);
                      } else if (val < 0.20) {
                        angle = (20 * math.pi / 180) -
                            ((val - 0.10) / 0.10) * (35 * math.pi / 180);
                      } else if (val < 0.30) {
                        angle = (-15 * math.pi / 180) +
                            ((val - 0.20) / 0.10) * (25 * math.pi / 180);
                      } else if (val < 0.40) {
                        angle = (10 * math.pi / 180) -
                            ((val - 0.30) / 0.10) * (15 * math.pi / 180);
                      } else if (val < 0.50) {
                        angle = (-5 * math.pi / 180) +
                            ((val - 0.40) / 0.10) * (5 * math.pi / 180);
                      }
                      return Transform.rotate(
                        angle: angle,
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        // Pulsing Red Badge Dot
        Positioned(
          top: 9,
          right: 9,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: const Color(0xFFF87171),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00B4DB),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AmbientBubblesPainter extends CustomPainter {
  final double progress;

  _AmbientBubblesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final bubbles = [
      _BubbleConfig(relX: 0.12, baseRadius: 16, speedMultiplier: 1.0, phaseOffset: 0.0),
      _BubbleConfig(relX: 0.65, baseRadius: 22, speedMultiplier: 0.8, phaseOffset: 0.25),
      _BubbleConfig(relX: 0.35, baseRadius: 12, speedMultiplier: 1.2, phaseOffset: 0.55),
      _BubbleConfig(relX: 0.88, baseRadius: 18, speedMultiplier: 0.9, phaseOffset: 0.75),
    ];

    for (final b in bubbles) {
      final t = (progress * b.speedMultiplier + b.phaseOffset) % 1.0;
      final y = size.height - (t * (size.height + 60));
      final x = size.width * b.relX + math.sin(t * math.pi * 2) * 8;
      final scale = 0.8 + 0.6 * t;
      final radius = b.baseRadius * scale;

      double opacity = 0.0;
      if (t < 0.2) {
        opacity = (t / 0.2) * 0.15;
      } else if (t < 0.7) {
        opacity = 0.15;
      } else {
        opacity = (1.0 - (t - 0.7) / 0.3) * 0.15;
      }

      paint.color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientBubblesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _BubbleConfig {
  final double relX;
  final double baseRadius;
  final double speedMultiplier;
  final double phaseOffset;

  const _BubbleConfig({
    required this.relX,
    required this.baseRadius,
    required this.speedMultiplier,
    required this.phaseOffset,
  });
}
