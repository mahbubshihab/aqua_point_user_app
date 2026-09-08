import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Highly optimized Animated Rain Particles + Ocean Waves Background,
/// pure light/white theme with zero frame drops and hardware-accelerated rendering.
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

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        for (final drop in _drops) {
          drop.y += drop.speed;
          drop.x += 0.0003;
          if (drop.y > 1.1) {
            drop.y = -0.05;
            drop.x = _random.nextDouble();
          }
        }
      })
      ..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    // 35 subtle drops instead of 120 for silky smooth performance
    for (int i = 0; i < 35; i++) {
      _drops.add(_createRandomDrop(isInitial: true));
    }
  }

  _RainDrop _createRandomDrop({bool isInitial = false}) {
    return _RainDrop(
      x: _random.nextDouble(),
      y: isInitial ? _random.nextDouble() : -0.1,
      length: _random.nextDouble() * 16 + 10,
      speed: _random.nextDouble() * 0.012 + 0.006,
      opacity: _random.nextDouble() * 0.35 + 0.15,
      width: _random.nextDouble() * 1.0 + 0.8,
    );
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

    // Pure Light Palette
    const bgGradient = LinearGradient(
      colors: [
        Color(0xFFE0F7FA),
        Color(0xFFE1F5FE),
        Color(0xFFF0F9FF),
        Color(0xFFE0F2FE),
        Color(0xFFBAE6FD),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    const rainColor = Color(0xFF0088FF);

    return Stack(
      children: [
        // 1. Background Gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: bgGradient),
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
              color: const Color(0xFF0088FF).withValues(alpha: 0.10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0088FF).withValues(alpha: 0.12),
                  blurRadius: 80,
                  spreadRadius: 30,
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
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.10),
                  blurRadius: 70,
                  spreadRadius: 25,
                ),
              ],
            ),
          ),
        ),

        // 3. Falling Rain Canvas (RepaintBoundary + Listenable CustomPainter - ZERO widget rebuilds)
        RepaintBoundary(
          child: CustomPaint(
            size: size,
            painter: _RainPainter(_drops, rainColor, repaint: _rainController),
          ),
        ),

        // 4. Animated Ocean Waves at Bottom (Isolated RepaintBoundary)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 180,
          child: RepaintBoundary(
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
  final Color rainColor;
  final Paint _paint = Paint()..strokeCap = StrokeCap.round;

  _RainPainter(this.drops, this.rainColor, {required Listenable repaint})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in drops) {
      final startX = drop.x * size.width;
      final startY = drop.y * size.height;
      final endX = startX + 1.5;
      final endY = startY + drop.length;

      _paint
        ..color = rainColor.withValues(alpha: drop.opacity)
        ..strokeWidth = drop.width;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), _paint);
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

    final color1 = const Color(0xFFB2EBF2).withValues(alpha: 0.65);
    final color2 = const Color(0xFF80DEEA).withValues(alpha: 0.45);
    final color3 = const Color(0xFF00BCE1).withValues(alpha: 0.2);

    // Wave 1
    final path1 = Path();
    path1.moveTo(0, height * 0.5);
    for (double i = 0; i <= width; i += 4) {
      final y = math.sin((i / width * 2 * math.pi) + (progress * math.pi)) * 12 + (height * 0.5);
      path1.lineTo(i, y);
    }
    path1.lineTo(width, height);
    path1.lineTo(0, height);
    path1.close();
    canvas.drawPath(path1, Paint()..color = color1);

    // Wave 2
    final path2 = Path();
    path2.moveTo(0, height * 0.6);
    for (double i = 0; i <= width; i += 4) {
      final y = math.sin((i / width * 3 * math.pi) - (progress * math.pi * 1.5)) * 16 + (height * 0.6);
      path2.lineTo(i, y);
    }
    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();
    canvas.drawPath(path2, Paint()..color = color2);

    // Wave 3
    final path3 = Path();
    path3.moveTo(0, height * 0.7);
    for (double i = 0; i <= width; i += 4) {
      final y = math.sin((i / width * 2.5 * math.pi) + (progress * math.pi * 2)) * 10 + (height * 0.7);
      path3.lineTo(i, y);
    }
    path3.lineTo(width, height);
    path3.lineTo(0, height);
    path3.close();
    canvas.drawPath(path3, Paint()..color = color3);
  }

  @override
  bool shouldRepaint(covariant _OceanWavesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
