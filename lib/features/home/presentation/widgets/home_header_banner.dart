import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeHeaderBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final int points;
  final VoidCallback? onPointsTap;
  final VoidCallback? onProfileTap;

  const HomeHeaderBanner({
    super.key,
    this.title = 'Salaam, Customer',
    this.subtitle = 'No. 1st দেশের প্রথম ওয়াটার অ্যাপ',
    this.points = 0,
    this.onPointsTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 16.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: Stack(
          children: [
            // Custom Cityscape Background Banner Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/header_banner.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF0F172A),
                  child: const Center(
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: 48,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ),
              ),
            ),
            // Dark Gradient Overlay fading seamlessly into the dark theme (#0F111A)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0F172A).withValues(alpha: 0.35),
                      const Color(0xFF0F111A).withValues(alpha: 0.75),
                      const Color(0xFF0F111A),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Floating Content
            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: topPadding,
                bottom: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Customer Profile Chip & Reward Points Pill Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Chip with Avatar Status Ring
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onProfileTap,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 4,
                              right: 12,
                              top: 4,
                              bottom: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFF334155),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Avatar with Status Ring
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF38BDF8),
                                        Color(0xFF10B981),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Color(0xFF1E293B),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 16,
                                      color: Color(0xFF38BDF8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Glowing Reward Points Pill Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onPointsTap,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFF59E0B).withValues(alpha: 0.2),
                                  const Color(0xFFD97706).withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.stars_rounded,
                                  size: 16,
                                  color: Color(0xFFFBBF24),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$points Points Use \u203A',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFBBF24),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Brand Logo & Tagline Row with Circular Glass Container
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Glass Container holding the Aqua Point Logo
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF38BDF8).withValues(alpha: 0.25),
                              const Color(0xFF10B981).withValues(alpha: 0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0EA5E9).withValues(alpha: 0.25),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/app_logo.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.water_drop_rounded,
                                size: 28,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Brand Title & Tagline Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                const Text(
                                  'AQUA POINT / মীম ওয়াটার',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF38BDF8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0EA5E9),
                                        Color(0xFF2563EB),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0EA5E9)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'No. 1st',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle.contains('দেশের প্রথম ওয়াটার অ্যাপ')
                                  ? (subtitle.startsWith('১ম - ')
                                      ? subtitle.replaceFirst('১ম - ', '')
                                      : (subtitle.startsWith('No. 1st ')
                                          ? subtitle.replaceFirst('No. 1st ', '')
                                          : subtitle))
                                  : subtitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.2,
                                height: 1.2,
                              ),
                            ),
                          ],
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


