import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated Rain Particles + Ocean Waves Background matching Admin Web Login screen!
class RainAndWavesBackground extends StatefulWidget {
  final Widget child;

  const RainAndWavesBackground({
    super.key,
    required this.child,
  });

  @override
  State<RainAndWavesBackground> createState() => _RainAndWavesBackgroundState();
}

class _RainAndWavesBackgroundState extends State<RainAndWavesBackground>
    with TickerProviderStateMixin {
  late AnimationController _rainController;
  late AnimationController _waveController;
  final List<_RainDrop> _drops = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Rain Animation Controller (60 FPS loop)
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
        _updateRainDrops();
      })
      ..repeat();

    // Wave Rolling Controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    // Initialize 120 Rain Drops
    for (int i = 0; i < 120; i++) {
      _drops.add(_createRandomDrop(isInitial: true));
    }
  }

  _RainDrop _createRandomDrop({bool isInitial = false}) {
    return _RainDrop(
      x: _random.nextDouble(),
      y: isInitial ? _random.nextDouble() : -0.1,
      length: _random.nextDouble() * 20 + 12,
      speed: _random.nextDouble() * 0.015 + 0.008,
      opacity: _random.nextDouble() * 0.4 + 0.15,
      width: _random.nextDouble() * 1.2 + 0.8,
    );
  }

  void _updateRainDrops() {
    if (!mounted) return;
    setState(() {
      for (var drop in _drops) {
        drop.y += drop.speed;
        drop.x += 0.0005; // Slight slant wind effect
        if (drop.y > 1.1) {
          drop.y = -0.05;
          drop.x = _random.nextDouble();
        }
      }
    });
  }

  @override
  void dispose() {
    _rainController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 1. Deep Midnight Ocean Background Gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF020810),
                Color(0xFF041220),
                Color(0xFF061828),
                Color(0xFF0A1E30),
                Color(0xFF0D2A3E),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // 2. Ambient Glow Orbs
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00BCE1).withValues(alpha: 0.08),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BCE1).withValues(alpha: 0.12),
                  blurRadius: 100,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3E4396).withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3E4396).withValues(alpha: 0.15),
                  blurRadius: 90,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),

        // 3. Falling Rain Canvas
        CustomPaint(
          size: size,
          painter: _RainPainter(_drops),
        ),

        // 4. Animated Ocean Waves at Bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 180,
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width, 180),
                painter: _OceanWavesPainter(_waveController.value),
              );
            },
          ),
        ),

        // 5. Foreground Content
        SafeArea(
          child: widget.child,
        ),
      ],
    );
  }
}

class _RainDrop {
  double x;
  double y;
  double length;
  double speed;
  double opacity;
  double width;

  _RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.opacity,
    required this.width,
  });
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> drops;

  _RainPainter(this.drops);

  @override
  void paint(Canvas canvas, Size size) {
    for (var drop in drops) {
      final startX = drop.x * size.width;
      final startY = drop.y * size.height;
      final endX = startX + 2;
      final endY = startY + drop.length;

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF00BCE1).withValues(alpha: 0.0),
            const Color(0xFF00BCE1).withValues(alpha: drop.opacity),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTRB(startX, startY, endX, endY))
        ..strokeWidth = drop.width
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) => true;
}

class _OceanWavesPainter extends CustomPainter {
  final double progress;

  _OceanWavesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Wave 1 - Deep Background Wave
    final path1 = Path();
    path1.moveTo(0, height * 0.5);
    for (double i = 0; i <= width; i++) {
      final y = math.sin((i / width * 2 * math.pi) + (progress * math.pi)) * 12 + (height * 0.5);
      path1.lineTo(i, y);
    }
    path1.lineTo(width, height);
    path1.lineTo(0, height);
    path1.close();
    canvas.drawPath(path1, Paint()..color = const Color(0xFF001E32).withValues(alpha: 0.85));

    // Wave 2 - Midground Cyan Wave
    final path2 = Path();
    path2.moveTo(0, height * 0.6);
    for (double i = 0; i <= width; i++) {
      final y = math.sin((i / width * 3 * math.pi) - (progress * math.pi * 1.5)) * 16 + (height * 0.6);
      path2.lineTo(i, y);
    }
    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();
    canvas.drawPath(path2, Paint()..color = const Color(0xFF003250).withValues(alpha: 0.5));

    // Wave 3 - Foreground Aqua Accent Wave
    final path3 = Path();
    path3.moveTo(0, height * 0.7);
    for (double i = 0; i <= width; i++) {
      final y = math.sin((i / width * 2.5 * math.pi) + (progress * math.pi * 2)) * 10 + (height * 0.7);
      path3.lineTo(i, y);
    }
    path3.lineTo(width, height);
    path3.lineTo(0, height);
    path3.close();
    canvas.drawPath(path3, Paint()..color = const Color(0xFF00BCE1).withValues(alpha: 0.08));
  }

  @override
  bool shouldRepaint(covariant _OceanWavesPainter oldDelegate) => true;
}
