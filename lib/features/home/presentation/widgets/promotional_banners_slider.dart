import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/help_support_page.dart';
import '../../../products/presentation/pages/shop_page.dart';

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
    final activeList = _activeBanners;
    if (activeList.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_currentIndex + 1) % activeList.length;
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
    final activeBanners = _activeBanners;

    if (activeBanners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 185,
          child: PageView.builder(
            controller: _pageController,
            itemCount: activeBanners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = activeBanners[index];
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
                    child: Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
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
                ),
              );
            },
          ),
        ),
        if (activeBanners.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              activeBanners.length,
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
    );
  }
}


