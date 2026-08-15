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

  void _showNotificationsSheet(BuildContext context) {
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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0x1F0083B0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Color(0xFF0083B0),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Recent updates & alerts',
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      '3 New',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0083B0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              // Notification 1: Service Scheduled
              _buildNotificationItem(
                icon: Icons.calendar_month_rounded,
                iconColor: const Color(0xFF0284C7),
                iconBgColor: const Color(0xFFE0F2FE),
                title: 'Service Scheduled',
                description:
                    'Routine filter maintenance scheduled for 15 Aug, 2026.',
                time: 'Scheduled',
                isUnread: true,
              ),

              const SizedBox(height: 10),

              // Notification 2: Hydration Reminder
              _buildNotificationItem(
                icon: Icons.water_drop_rounded,
                iconColor: const Color(0xFF00B4DB),
                iconBgColor: const Color(0xFFDEF3FC),
                title: 'Hydration Reminder',
                description:
                    'Remember to drink alkaline water for optimal pH balance.',
                time: '2 hours ago',
                isUnread: true,
              ),

              const SizedBox(height: 10),

              // Notification 3: Special Offer
              _buildNotificationItem(
                icon: Icons.workspace_premium_rounded,
                iconColor: const Color(0xFFD97706),
                iconBgColor: const Color(0xFFFEF3C7),
                title: 'Special Offer',
                description:
                    '15% discount on Annual Maintenance Care (AMC) subscription.',
                time: '1 day ago',
                isUnread: false,
                tag: '15% OFF',
              ),

              const SizedBox(height: 20),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0083B0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(modalContext),
                  child: Text(
                    'Dismiss',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
    String? tag,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    if (tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      )
                    else
                      Text(
                        time,
                        style: GoogleFonts.poppins(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF475569),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                        onTap: widget.onNotificationTap ??
                            () => _showNotificationsSheet(context),
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
