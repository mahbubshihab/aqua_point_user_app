import 'package:flutter/material.dart';

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

    return Container(
      width: double.infinity,
      color: const Color(0xFF0F111A),
      child: Stack(
        children: [
          // Custom Cityscape Background Banner Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/header_banner.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF0F111A),
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
          // Dark Gradient Overlay fading seamlessly into background color (#0F111A)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F111A).withValues(alpha: 0.25),
                    const Color(0xFF0F111A).withValues(alpha: 0.65),
                    const Color(0xFF0F111A).withValues(alpha: 0.95),
                    const Color(0xFF0F111A),
                  ],
                  stops: const [0.0, 0.45, 0.8, 1.0],
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Brand Logo & Title Badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
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
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.water_drop_rounded,
                                size: 20,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'মীম ওয়াটার',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Main Row: Customer Profile Chip & Reward Points Pill Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Pill Widget: White Glass Surface Profile Chip
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
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
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
                                      Color(0xFF38BDF8),
                                      Color(0xFF0284C7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'C',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Right Pill Widget: Glowing Gold/White Pill Button
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
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFFBEB),
                                Color(0xFFFEF3C7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFF59E0B),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                size: 17,
                                color: Color(0xFFD97706),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$points Points Use \u203A',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF92400E),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}



