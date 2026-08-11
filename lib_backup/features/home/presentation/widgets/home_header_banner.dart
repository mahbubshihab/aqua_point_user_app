import 'dart:ui';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

class HomeHeaderBanner extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const HomeHeaderBanner({
    super.key,
    this.onProfileTap,
  });

  @override
  State<HomeHeaderBanner> createState() => _HomeHeaderBannerState();
}

class _HomeHeaderBannerState extends State<HomeHeaderBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients && _totalPages > 1) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _totalPages) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 14.0;
    
    // Get userId from AuthBloc
    final authState = context.read<AuthBloc>().state;
    String? userId;
    if (authState is Authenticated) {
      userId = authState.userId;
    }

    return Container(
      width: double.infinity,
      color: AppColors.background,
      // Fixed height to give banner a nice size
      height: topPadding + 180,
      child: Stack(
        children: [
          // Banner Image from Firestore Slider
          Positioned.fill(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('banners')
                  .where('isActive', isEqualTo: true)
                  .orderBy('order')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  _totalPages = 0;
                  return _buildFallbackBanner();
                }

                final docs = snapshot.data!.docs;
                _totalPages = docs.length;

                return Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final imageUrl = data['imageUrl'] as String?;
                        
                        if (imageUrl == null || imageUrl.isEmpty) {
                          return _buildFallbackBanner();
                        }
                        
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => _buildFallbackBanner(),
                        );
                      },
                    ),
                    // Dot indicators
                    if (docs.length > 1)
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(docs.length, (index) {
                            final isActive = _currentPage == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 12 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                );
              },
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
          
          // Floating Content Overlay
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: topPadding,
              bottom: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top Row: Brand Logo and Profile Chip in the same row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Brand Logo
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
                    
                    // Right: Profile Chip
                    _buildProfileChip(userId),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackBanner() {
    return Image.asset(
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
    );
  }

  Widget _buildProfileChip(String? userId) {
    if (userId == null) {
      return _buildChipUI('My Profile', null);
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('customers').doc(userId).get(),
      builder: (context, snapshot) {
        String displayName = 'My Profile';
        String? avatarUrl;
        
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data.containsKey('name') && data['name'] != null && data['name'].toString().isNotEmpty) {
            displayName = data['name'];
          }
          if (data.containsKey('avatarUrl')) {
            avatarUrl = data['avatarUrl'];
          }
        }

        return _buildChipUI(displayName, avatarUrl);
      },
    );
  }

  Widget _buildChipUI(String name, String? avatarUrl) {
    final initialLetter = name.isNotEmpty && name != 'My Profile' ? name[0].toUpperCase() : null;

    return Flexible(
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
                          child: ClipOval(
                            child: avatarUrl != null && avatarUrl.isNotEmpty
                                ? Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => _buildFallbackAvatar(initialLetter),
                                  )
                                : _buildFallbackAvatar(initialLetter),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            name,
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
    );
  }

  Widget _buildFallbackAvatar(String? initialLetter) {
    if (initialLetter != null) {
      return Center(
        child: Text(
          initialLetter,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A0D16),
          ),
        ),
      );
    } else {
      return const Center(
        child: Icon(
          Icons.person,
          size: 16,
          color: Color(0xFF0A0D16),
        ),
      );
    }
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
