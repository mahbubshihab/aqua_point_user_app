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
    this.subtitle = '',
    this.points = 0,
    this.onPointsTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 14.0;
    final initialLetter = title.isNotEmpty ? title[0].toUpperCase() : 'C';

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
          // Top-to-bottom Dark Gradient Fade blending seamlessly into #0A0D16
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.divider,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
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
                            'মীম ওয়াটার',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Row 2: Left Glass Profile Chip & Right Minimal Points Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Glass Profile Chip (`C Salaam, Customer`)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onProfileTap,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 14,
                            top: 4,
                            bottom: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.divider,
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
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

                    // Right: Minimal Points Chip (`⭐ 0 Points`)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onPointsTap,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.accentGold.withValues(alpha: 0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGold.withValues(alpha: 0.15),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '⭐',
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$points Points',
                                style: const TextStyle(
                                  fontSize: 12,
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




