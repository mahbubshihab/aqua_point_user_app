import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiHydrationTankCard extends StatefulWidget {
  final double initialLiters;
  final double goalLiters;

  const AiHydrationTankCard({
    super.key,
    this.initialLiters = 1.6,
    this.goalLiters = 2.5,
  });

  @override
  State<AiHydrationTankCard> createState() => _AiHydrationTankCardState();
}

class _AiHydrationTankCardState extends State<AiHydrationTankCard>
    with TickerProviderStateMixin {
  late double _currentLiters;
  late final double _goalLiters;

  late final AnimationController _waveController;
  late final AnimationController _auraController;
  late final AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _currentLiters = widget.initialLiters;
    _goalLiters = widget.goalLiters;

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _auraController.dispose();
    _pingController.dispose();
    super.dispose();
  }

  void _addWater(double amount) {
    setState(() {
      _currentLiters = (_currentLiters + amount).clamp(0.0, _goalLiters);
    });
  }

  int get _percent {
    return ((_currentLiters / _goalLiters) * 100).round().clamp(0, 100);
  }

  Widget _buildAdviceText() {
    final remaining = (_goalLiters - _currentLiters).clamp(0.0, _goalLiters).toStringAsFixed(1);

    if (_currentLiters == 0) {
      return RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
            height: 1.45,
          ),
          children: const [
            TextSpan(text: 'Good start! Drink a glass of '),
            TextSpan(
              text: 'Alkaline Water',
              style: TextStyle(
                color: Color(0xFF0083B0),
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(text: ' to boost morning metabolism.'),
          ],
        ),
      );
    } else if (_percent < 50) {
      return RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
            height: 1.45,
          ),
          children: [
            const TextSpan(text: 'Keep going! Drink '),
            TextSpan(
              text: '${remaining}L',
              style: const TextStyle(
                color: Color(0xFF0083B0),
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: ' more to maintain optimal pH & body energy.'),
          ],
        ),
      );
    } else if (_percent < 100) {
      return RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
            height: 1.45,
          ),
          children: [
            const TextSpan(text: 'Great progress! Your cells are well-hydrated. Just '),
            TextSpan(
              text: '${remaining}L',
              style: const TextStyle(
                color: Color(0xFF0083B0),
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(text: " left for today's target."),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
            height: 1.45,
          ),
          children: const [
            TextSpan(
              text: 'Goal Completed! ',
              style: TextStyle(
                color: Color(0xFF00A859),
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(text: 'Your body is fully detoxified and mineralized.'),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillFraction = (_currentLiters / _goalLiters).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xF2FFFFFF), Color(0xE6DCF3FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0x5900B4DB),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260083B0),
            blurRadius: 35,
            offset: Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Icon + Title + AI Active Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Header
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0x2600B4DB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.opacity_rounded,
                            color: Color(0xFF0083B0),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI HEALTH & HYDRATION',
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF005C97),
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              'Smart Alkaline Water Monitor',
                              style: GoogleFonts.poppins(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right: AI Active Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1A00B4DB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0x4D00B4DB),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pingController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: (1.0 - _pingController.value * 0.6).clamp(0.0, 1.0),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF00B4DB),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'AI Active',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0083B0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Main Content: Liquid Tank Cylinder + Details Column
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Liquid Tank Cylinder (80x115)
                    SizedBox(
                      width: 80,
                      height: 115,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing Tank Aura behind cylinder
                          AnimatedBuilder(
                            animation: _auraController,
                            builder: (context, child) {
                              final scale = 1.0 + _auraController.value * 0.08;
                              final opacity = 0.12 + _auraController.value * 0.15;
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 80,
                                  height: 115,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00B4DB).withValues(alpha: opacity),
                                        blurRadius: 16,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Tank Container with border and inner liquid wave
                          Container(
                            width: 80,
                            height: 115,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDEF3FC),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.95),
                                width: 2.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A0083B0),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  // Animated Water Wave
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0.0,
                                      end: fillFraction,
                                    ),
                                    duration: const Duration(milliseconds: 1000),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, fillVal, child) {
                                      return AnimatedBuilder(
                                        animation: _waveController,
                                        builder: (context, child) {
                                          return CustomPaint(
                                            size: const Size(80, 115),
                                            painter: _TankWavePainter(
                                              fillRatio: fillVal,
                                              progress: _waveController.value,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  // Percentage Badge in Center
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.90),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x26005C97),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '$_percent%',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF005C97),
                                          height: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Right Info & Actions Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Consumed vs Goal Row
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0x3300B4DB),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CONSUMED',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF9CA3AF),
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      '${_currentLiters.toStringAsFixed(1)} L',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'DAILY GOAL',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0083B0),
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      '${_goalLiters.toStringAsFixed(1)} L',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF005C97),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Dynamic AI Advice
                          _buildAdviceText(),

                          const SizedBox(height: 12),

                          // +250ml and +500ml Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _WaterAddButton(
                                  label: '+ 250ml',
                                  onTap: () => _addWater(0.25),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _WaterAddButton(
                                  label: '+ 500ml',
                                  onTap: () => _addWater(0.50),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WaterAddButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _WaterAddButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_WaterAddButton> createState() => _WaterAddButtonState();
}

class _WaterAddButtonState extends State<_WaterAddButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330083B0),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 13,
              ),
              const SizedBox(width: 3),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TankWavePainter extends CustomPainter {
  final double fillRatio;
  final double progress;

  _TankWavePainter({
    required this.fillRatio,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (fillRatio <= 0.0) return;

    final targetY = size.height * (1.0 - fillRatio);

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, targetY);

    const waveHeight = 4.0;
    final waveLength = size.width * 1.2;
    final offset = progress * waveLength * 2;

    for (double x = 0; x <= size.width; x += 2) {
      final y = targetY + math.sin((x + offset) * 2 * math.pi / waveLength) * waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xE600B4DB),
          Color(0xF5005C97),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Second lighter crest
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, targetY);

    final offset2 = (progress * waveLength * 2) + waveLength * 0.4;
    for (double x = 0; x <= size.width; x += 2) {
      final y = targetY + math.cos((x + offset2) * 2 * math.pi / waveLength) * (waveHeight * 0.7);
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();

    final paint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00B4DB).withValues(alpha: 0.35),
          const Color(0xFF005C97).withValues(alpha: 0.20),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _TankWavePainter oldDelegate) {
    return oldDelegate.fillRatio != fillRatio || oldDelegate.progress != progress;
  }
}
