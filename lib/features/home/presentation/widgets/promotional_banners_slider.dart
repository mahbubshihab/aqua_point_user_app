import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/help_support_page.dart';
import '../../../products/presentation/pages/shop_page.dart';
import '../../../profile_rewards/presentation/pages/reward_points_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';
import '../../../tools/presentation/pages/tds_meter_page.dart';
import '../../../tools/presentation/pages/water_reminder_page.dart';
import '../../domain/entities/banner_entity.dart';

class PromotionalBannersSlider extends StatefulWidget {
  final List<BannerEntity> banners;

  const PromotionalBannersSlider({
    super.key,
    required this.banners,
  });

  @override
  State<PromotionalBannersSlider> createState() => _PromotionalBannersSliderState();
}

class _PromotionalBannersSliderState extends State<PromotionalBannersSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  List<BannerEntity> get _activeBanners =>
      widget.banners.where((b) => b.isActive).toList();

  List<BannerEntity> get _mainBanners {
    final active = _activeBanners;
    if (active.isEmpty) return [];

    final explicitMain = active
        .where((b) =>
            b.position == 'main' ||
            b.position == 'hero' ||
            b.position == null ||
            b.position!.isEmpty)
        .toList();
    final explicitPromo = active
        .where((b) =>
            b.position == 'promo' ||
            b.position == 'side' ||
            b.position == 'bottom')
        .toList();

    if (explicitPromo.isNotEmpty) {
      return explicitMain.isNotEmpty ? explicitMain : active;
    }

    if (active.length >= 3) {
      return active.sublist(0, 2);
    }
    return active;
  }

  List<BannerEntity> get _promoBanners {
    final active = _activeBanners;
    if (active.isEmpty) return [];

    final explicitPromo = active
        .where((b) =>
            b.position == 'promo' ||
            b.position == 'side' ||
            b.position == 'bottom')
        .toList();
    if (explicitPromo.isNotEmpty) {
      return explicitPromo;
    }

    if (active.length >= 3) {
      return active.sublist(2);
    } else if (active.length == 2) {
      return [active.last];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant PromotionalBannersSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners != widget.banners) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer?.cancel();
    final mainList = _mainBanners;
    if (mainList.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_currentIndex + 1) % mainList.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleBannerTap(BuildContext context, BannerEntity banner) async {
    final cta = banner.ctaLink?.trim() ?? '';
    if (cta.isNotEmpty) {
      if (cta.startsWith('http://') || cta.startsWith('https://')) {
        final uri = Uri.parse(cta);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      } else {
        final route = cta.toLowerCase();
        if (route.contains('shop') || route.contains('product') || route.contains('store')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ShopPage()),
          );
          return;
        } else if (route.contains('service') || route.contains('repair') || route.contains('request')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ServicesBloc>(),
                child: const CreateServiceRequestPage(),
              ),
            ),
          );
          return;
        } else if (route.contains('point') || route.contains('reward')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RewardPointsPage()),
          );
          return;
        } else if (route.contains('help') || route.contains('support')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpSupportPage()),
          );
          return;
        } else if (route.contains('water') || route.contains('reminder')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WaterReminderPage()),
          );
          return;
        } else if (route.contains('tds')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TdsMeterPage()),
          );
          return;
        }
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  banner.title,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainList = _mainBanners;
    final promoList = _promoBanners;

    if (mainList.isEmpty && promoList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Main Hero Carousel Slider
        if (mainList.isNotEmpty) ...[
          SizedBox(
            height: 185,
            child: PageView.builder(
              controller: _pageController,
              itemCount: mainList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = mainList[index];
                return GestureDetector(
                  onTap: () => _handleBannerTap(context, banner),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0x2B00E5FF),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              banner.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.cardBackground,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    color: AppColors.textSecondary,
                                    size: 40,
                                  ),
                                ),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: AppColors.cardBackground,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.85),
                                    Colors.black.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (banner.tag != null && banner.tag!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.primary.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Text(
                                          banner.tag!,
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  banner.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
                                  ),
                                ),
                                if (banner.subtitle != null && banner.subtitle!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    banner.subtitle!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (mainList.length > 1) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                mainList.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == index ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.primary
                        : AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: _currentIndex == index
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ],

        // 2. Promo Side Banner Section Underneath Carousel
        if (promoList.isNotEmpty) ...[
          const Gap(16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_offer_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Promotions & Special Offers',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.accentYellow.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'LIMITED',
                  style: TextStyle(
                    color: AppColors.accentYellow,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: promoList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final banner = promoList[index];
                return GestureDetector(
                  onTap: () => _handleBannerTap(context, banner),
                  child: Container(
                    width: promoList.length == 1
                        ? MediaQuery.of(context).size.width - 32
                        : 290,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0x2B00E5FF),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 105,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    banner.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: const Color(0xFF1E293B),
                                      child: const Icon(
                                        Icons.image_not_supported_rounded,
                                        color: AppColors.textSecondary,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.4),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (banner.tag != null && banner.tag!.isNotEmpty) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        banner.tag!,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Text(
                                    banner.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        banner.ctaLink != null && banner.ctaLink!.isNotEmpty
                                            ? 'Explore'
                                            : 'View Offer',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: AppColors.primary,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

