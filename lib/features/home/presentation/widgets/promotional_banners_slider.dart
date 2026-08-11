import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../inbox_support/presentation/pages/chat_conversation_page.dart';
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
  State<PromotionalBannersSlider> createState() =>
      _PromotionalBannersSliderState();
}

class _PromotionalBannersSliderState extends State<PromotionalBannersSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoScrollTimer;

  List<BannerEntity> get _activeBanners =>
      widget.banners.where((b) => b.isActive).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant PromotionalBannersSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.banners != widget.banners) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    final activeList = _activeBanners;
    if (activeList.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!mounted || !_pageController.hasClients) return;
        final nextPage = (_currentIndex + 1) % activeList.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
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
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
          return;
        } else if (route.contains('service') || route.contains('repair') || route.contains('request')) {
          final servicesBloc = context.read<ServicesBloc>();
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: servicesBloc,
              child: const CreateServiceRequestPage(),
            ),
          ));
          return;
        } else if (route.contains('help') || route.contains('support')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatConversationPage()));
          return;
        } else if (route.contains('water') || route.contains('reminder')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterReminderPage()));
          return;
        } else if (route.contains('tds')) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TdsMeterPage()));
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
              const Icon(Icons.info_outline, color: Colors.white, size: 20),
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
          backgroundColor: AppColors.textPrimary,
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
    if (activeBanners.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: activeBanners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = activeBanners[index];
              return GestureDetector(
                onTap: () => _handleBannerTap(context, banner),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? AppColors.darkSurfaceVariant : AppColors.divider,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                            size: 40,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: isDark ? AppColors.darkSurfaceVariant : AppColors.divider,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              activeBanners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? theme.colorScheme.primary
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
