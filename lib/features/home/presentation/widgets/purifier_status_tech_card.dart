import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';

class PurifierStatusTechCard extends StatefulWidget {
  final String lastServiceDate;
  final String nextServiceDate;
  final String filtrationStatus;
  final String deviceStatus;
  final VoidCallback? onTap;

  const PurifierStatusTechCard({
    super.key,
    this.lastServiceDate = '15 May, 2026',
    this.nextServiceDate = '15 Aug, 2026',
    this.filtrationStatus = 'Optimal',
    this.deviceStatus = 'Active',
    this.onTap,
  });

  @override
  State<PurifierStatusTechCard> createState() => _PurifierStatusTechCardState();
}

class _PurifierStatusTechCardState extends State<PurifierStatusTechCard>
    with TickerProviderStateMixin {
  late final AnimationController _spinController;
  late final AnimationController _pingController;
  late final AnimationController _waveController;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pingController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _showPurifierStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x26005C97),
                blurRadius: 30,
                offset: Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(modalContext).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
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
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Purifier Diagnostics',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Active filtration statistics',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6FCF0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0x6600D26A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00D26A),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Active & Optimal',
                          style: GoogleFonts.poppins(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00A859),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 2x2 Diagnostics Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Membrane Health',
                      value: '98%',
                      subtext: 'Optimal Filtration',
                      color: const Color(0xFF00A859),
                      bgColor: const Color(0xFFE6FCF0),
                      icon: Icons.health_and_safety_rounded,
                      showProgress: true,
                      progressValue: 0.98,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Input TDS',
                      value: '380 PPM',
                      subtext: 'Raw Tap Water',
                      color: const Color(0xFFE65100),
                      bgColor: const Color(0xFFFFF3E0),
                      icon: Icons.waterfall_chart_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Output Pure TDS',
                      value: '45 PPM',
                      subtext: 'Alkaline & Pure',
                      color: const Color(0xFF0083B0),
                      bgColor: const Color(0xFFDEF3FC),
                      icon: Icons.check_circle_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'System Status',
                      value: 'Active',
                      subtext: 'All 5 Stages OK',
                      color: const Color(0xFF0284C7),
                      bgColor: const Color(0xFFE0F2FE),
                      icon: Icons.tune_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Schedule Info Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LAST SERVICE',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF94A3B8),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.lastServiceDate,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: const Color(0xFFCBD5E1),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'NEXT SCHEDULED',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0083B0),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.nextServiceDate,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF005C97),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Request Maintenance Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0083B0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(modalContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateServiceRequestPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.build_rounded, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Request Maintenance',
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String subtext,
    required Color color,
    required Color bgColor,
    required IconData icon,
    bool showProgress = false,
    double progressValue = 0.0,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              Icon(icon, color: color, size: 15),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          if (showProgress) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 4,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            subtext,
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () => _showPurifierStatusSheet(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFE6F7FC)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F0083B0),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x1400B4DB),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Top sheen gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x260083B0),
                        Color(0x0D00B4DB),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Tech Particles Animation
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _TechParticlesPainter(
                        progress: _particleController.value,
                      ),
                    );
                  },
                ),
              ),

              // Bottom Water Wave Animation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 24,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _BottomWaterWavePainter(
                        progress: _waveController.value,
                      ),
                    );
                  },
                ),
              ),

              // Main Card Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Row: Icon + Status + Active Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Droplet with Dashed Ring and Title
                        Row(
                          children: [
                            // Animated Droplet Icon
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Rotating Dashed Ring
                                  AnimatedBuilder(
                                    animation: _spinController,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _spinController.value * 2 * math.pi,
                                        child: CustomPaint(
                                          size: const Size(48, 48),
                                          painter: _DashedCirclePainter(
                                            color: const Color(0x9900B4DB),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Pulsing Ping Ring
                                  AnimatedBuilder(
                                    animation: _pingController,
                                    builder: (context, child) {
                                      final pingVal = _pingController.value;
                                      return Opacity(
                                        opacity: (1.0 - pingVal).clamp(0.0, 1.0),
                                        child: Transform.scale(
                                          scale: 0.8 + 0.5 * pingVal,
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0x660083B0),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Center Gradient Circle with Droplet
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x400083B0),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.water_drop_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Titles
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Purifier Status',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF005C97),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    _PulsingDot(
                                      color: const Color(0xFF00B4DB),
                                      size: 6,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Filtration: ',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      widget.filtrationStatus,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF0083B0),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Right: Active Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6FCF0),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0x4D00D26A),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1000A859),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _PulsingDot(
                                color: const Color(0xFF00D26A),
                                size: 6,
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.water_drop_rounded,
                                color: Color(0xFF00A859),
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.deviceStatus.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF00A859),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Compact Date Panel
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xD9FFFFFF), Color(0xF2E6F7FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0x4000B4DB),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D005C97),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Last Service
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFF1F5F9),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x0A000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.history_toggle_off_rounded,
                                    color: Color(0xFF6B7280),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'LAST SERVICE',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF6B7280),
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        widget.lastServiceDate,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF1F2937),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 32,
                            color: const Color(0x4D00B4DB),
                          ),
                          const SizedBox(width: 8),

                          // Next Service
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          _PulsingDot(
                                            color: const Color(0xFF00B4DB),
                                            size: 5,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'NEXT SERVICE',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF0083B0),
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        widget.nextServiceDate,
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF005C97),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x330083B0),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.event_available_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulsingDot({required this.color, required this.size});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: (1.0 - _controller.value).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 1.0 + _controller.value * 1.2,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final radius = size.width / 2;
    const dashCount = 8;
    const dashLength = (2 * math.pi) / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * 2 * dashLength;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius - 1),
        startAngle,
        dashLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _BottomWaterWavePainter extends CustomPainter {
  final double progress;

  _BottomWaterWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF00B4DB).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF0083B0).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    final path2 = Path();

    path1.moveTo(0, size.height);
    path2.moveTo(0, size.height);

    const waveHeight = 7.0;
    final waveLength = size.width * 0.8;
    final offset1 = progress * waveLength * 2;
    final offset2 = (progress * waveLength * 2) + waveLength * 0.5;

    for (double x = 0; x <= size.width; x += 3) {
      final y1 = size.height * 0.45 +
          math.sin((x + offset1) * 2 * math.pi / waveLength) * waveHeight;
      path1.lineTo(x, y1);

      final y2 = size.height * 0.55 +
          math.cos((x + offset2) * 2 * math.pi / waveLength) * (waveHeight * 0.8);
      path2.lineTo(x, y2);
    }

    path1.lineTo(size.width, size.height);
    path1.close();

    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _BottomWaterWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TechParticlesPainter extends CustomPainter {
  final double progress;

  _TechParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final particles = [
      _ParticleConfig(relX: 0.12, radius: 10, speed: 1.0, phase: 0.0),
      _ParticleConfig(relX: 0.52, radius: 6, speed: 1.3, phase: 0.35),
      _ParticleConfig(relX: 0.82, radius: 12, speed: 0.8, phase: 0.7),
    ];

    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final y = size.height - (t * (size.height + 30));
      final x = size.width * p.relX + math.sin(t * math.pi * 2) * 6;
      final currentRadius = p.radius * (0.6 + 0.4 * t);

      double opacity = 0.0;
      if (t < 0.2) {
        opacity = (t / 0.2) * 0.3;
      } else if (t < 0.8) {
        opacity = 0.3;
      } else {
        opacity = (1.0 - (t - 0.8) / 0.2) * 0.3;
      }

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF00B4DB).withValues(alpha: opacity),
            const Color(0xFF0083B0).withValues(alpha: opacity * 1.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: currentRadius))
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = const Color(0xFF00B4DB).withValues(alpha: opacity * 1.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(Offset(x, y), currentRadius, fillPaint);
      canvas.drawCircle(Offset(x, y), currentRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TechParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticleConfig {
  final double relX;
  final double radius;
  final double speed;
  final double phase;

  const _ParticleConfig({
    required this.relX,
    required this.radius,
    required this.speed,
    required this.phase,
  });
}
