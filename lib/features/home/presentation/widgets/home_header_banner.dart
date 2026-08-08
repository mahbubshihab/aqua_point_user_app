import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeaderBanner extends StatefulWidget {
  final String title;
  final String subtitle;
  final int points;
  final VoidCallback? onPointsTap;
  final VoidCallback? onProfileTap;

  const HomeHeaderBanner({
    super.key,
    this.title = 'Salaam, Customer',
    this.subtitle = '',
    this.points = 0,
    this.onPointsTap,
    this.onProfileTap,
  });

  @override
  State<HomeHeaderBanner> createState() => _HomeHeaderBannerState();
}

class _HomeHeaderBannerState extends State<HomeHeaderBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 14.0;
    final initialLetter = widget.title.isNotEmpty ? widget.title[0].toUpperCase() : 'C';

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Stack(
        children: [
          // Panoramic City Skyline Overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/header_banner.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.background,
                child: const Center(
                  child: Icon(
                    Icons.water_drop_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          
          // Animated Water Ripple Effect
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WaterRipplePainter(_controller.value),
                );
              },
            ),
          ),
          
          // Top-to-bottom Dark Gradient Fade
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background.withValues(alpha: 0.3),
                    AppColors.background.withValues(alpha: 0.65),
                    AppColors.background.withValues(alpha: 0.92),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.45, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          // Subtle gradient shimmer overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      begin: Alignment(-1.0 + _controller.value * 2, 0.0),
                      end: Alignment(0.0 + _controller.value * 2, 0.0),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Floating Content Overlay
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: topPadding,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Clean Brand Logo Badge in Frosted Glass Pill
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0x1F1A2236),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0x2B00E5FF),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x2B00E5FF).withValues(alpha: 0.15),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  height: 22,
                                  width: 22,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.water_drop_rounded,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AQUA POINT',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Badge: #1 Water App in Bangladesh (Glowing)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final glow = math.sin(_controller.value * math.pi * 2) * 0.5 + 0.5;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3 + glow * 0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: glow * 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Text(
                                '#1 Water App in Bangladesh',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Row 2: Left Glass Profile Chip & Right Minimal Points Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Glass Profile Chip (`C Salaam, Customer`)
                    Flexible(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final pulse = math.sin(_controller.value * math.pi * 2) * 0.5 + 0.5;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: widget.onProfileTap,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      right: 14,
                                      top: 4,
                                      bottom: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1F1A2236),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: const Color(0x2B00E5FF).withValues(alpha: 0.2 + pulse * 0.3),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.secondary,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: pulse * 0.4),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              initialLetter,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0A0D16),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            widget.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Right: Minimal Points Chip (`⭐ 0 Points`)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final pulse = math.sin(_controller.value * math.pi * 2 + math.pi) * 0.5 + 0.5; // Offset phase
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onPointsTap,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x1F1A2236),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppColors.accentGold.withValues(alpha: 0.4 + pulse * 0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accentGold.withValues(alpha: 0.15 + pulse * 0.15),
                                        blurRadius: 10 + pulse * 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '⭐',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${widget.points} Points',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.accentGold,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterRipplePainter extends CustomPainter {
  final double progress;

  _WaterRipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1 * (1 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);

    for (int i = 0; i < 3; i++) {
      final currentProgress = (progress + i / 3.0) % 1.0;
      final radius = maxRadius * currentProgress;
      paint.color = AppColors.primary.withValues(alpha: 0.15 * (1 - currentProgress));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaterRipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
