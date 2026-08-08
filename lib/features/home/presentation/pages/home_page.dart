import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/help_support_page.dart';
import '../../../products/presentation/pages/shop_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';
import '../../../services/presentation/pages/services_history_page.dart';
import '../../../tools/presentation/pages/blogs_news_page.dart';
import '../../../tools/presentation/pages/store_locator_page.dart';
import '../../../tools/presentation/pages/tds_meter_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../tools/presentation/pages/water_reminder_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/blogs_news_section.dart';
import '../widgets/categories_section.dart';

import '../widgets/home_header_banner.dart';
import '../widgets/hydration_tracker_widget.dart';
import '../widgets/my_products_section.dart';
import '../widgets/product_type_section.dart';
import '../widgets/promotional_banners_slider.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/services_grid.dart';
import '../widgets/water_quality_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _AnimatedAuroraBackground(),
          SafeArea(
            top: false,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading || state is HomeInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.accentRed, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(const LoadHomeData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.cardBackground,
                onRefresh: () async {
                  context.read<HomeBloc>().add(const LoadHomeData());
                  await Future.delayed(const Duration(milliseconds: 600));
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeaderBanner(
                      onProfileTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                    const Gap(14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.banners.isNotEmpty) ...[
                            PromotionalBannersSlider(banners: state.banners),
                            const Gap(14),
                          ],
                          QuickActionGrid(
                            items: [
                              QuickActionItem(
                                label: 'Request Service',
                                icon: Icons.home_repair_service_rounded,
                                iconColor: const Color(0xFF00E5FF),
                                gradientColors: const [Color(0xFF1D4ED8), Color(0xFF00E5FF)],
                                glowColor: const Color(0x5500E5FF),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<ServicesBloc>(),
                                        child: const CreateServiceRequestPage(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              QuickActionItem(
                                label: 'Shop',
                                icon: Icons.shopping_bag_rounded,
                                iconColor: const Color(0xFF10B981),
                                gradientColors: const [Color(0xFF047857), Color(0xFF10B981)],
                                glowColor: const Color(0x5510B981),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ShopPage(),
                                    ),
                                  );
                                },
                              ),
                              QuickActionItem(
                                label: 'Invoices',
                                icon: Icons.receipt_long_rounded,
                                iconColor: const Color(0xFFF59E0B),
                                gradientColors: const [Color(0xFFB45309), Color(0xFFF59E0B)],
                                glowColor: const Color(0x55F59E0B),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<ServicesBloc>(),
                                        child: const ServicesHistoryPage(initialTabIndex: 2),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              QuickActionItem(
                                label: 'Support',
                                icon: Icons.support_agent_rounded,
                                iconColor: const Color(0xFFEC4899),
                                gradientColors: const [Color(0xFFBE185D), Color(0xFFEC4899)],
                                glowColor: const Color(0x55EC4899),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Gap(14),
                          CategoriesSection(categories: state.categories),
                          const Gap(14),
                          MyProductsSection(
                            onViewAllTap: () {
                              context.read<HomeBloc>().add(const SelectTab(2));
                            },
                          ),

                          const Gap(14),
                          HydrationTrackerWidget(
                            hydration: state.hydration,
                            onIncrement: () {
                              context.read<HomeBloc>().add(const IncrementHydration());
                            },
                            onDecrement: () {
                              context.read<HomeBloc>().add(const DecrementHydration());
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const WaterReminderPage()),
                              );
                            },
                          ),
                          const Gap(14),
                          WaterQualityCard(
                            waterQuality: state.waterQuality,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TdsMeterPage(waterQuality: state.waterQuality),
                                ),
                              );
                            },
                          ),
                          const Gap(14),
                          ServicesGrid(
                            services: [
                              ServiceTileData(
                                title: 'Schedule Service',
                                description: 'Filter replacement & maintenance',
                                icon: Icons.calendar_month_outlined,
                                color: AppColors.primary,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<ServicesBloc>(),
                                        child: const CreateServiceRequestPage(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ServiceTileData(
                                title: 'Water Reminder',
                                description: 'Stay hydrated with alerts',
                                icon: Icons.alarm_rounded,
                                color: AppColors.accentGreen,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const WaterReminderPage()),
                                  );
                                },
                              ),
                              ServiceTileData(
                                title: 'Store Locator',
                                description: 'Find nearest Aqua Point branch',
                                icon: Icons.location_on_outlined,
                                color: AppColors.accentYellow,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const StoreLocatorPage()),
                                  );
                                },
                              ),
                              ServiceTileData(
                                title: 'Transaction History',
                                description: 'View orders and bills',
                                icon: Icons.history_edu_rounded,
                                color: const Color(0xFFA855F7),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<ServicesBloc>(),
                                        child: const ServicesHistoryPage(initialTabIndex: 1),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Gap(14),
                          BlogsNewsSection(
                            blogs: state.blogs,
                            onViewAllTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlogsNewsPage(initialBlogs: state.blogs),
                                ),
                              );
                            },
                            onBlogTap: (blog) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlogsNewsPage(initialBlogs: state.blogs),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

            return const SizedBox.shrink();
          },
        ),
      ),
        ],
      ),
    );
  }
}

class _AnimatedAuroraBackground extends StatefulWidget {
  const _AnimatedAuroraBackground();

  @override
  State<_AnimatedAuroraBackground> createState() => _AnimatedAuroraBackgroundState();
}

class _AnimatedAuroraBackgroundState extends State<_AnimatedAuroraBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.8 + _controller.value * 0.4),
              radius: 1.5 + _controller.value * 0.2,
              colors: [
                AppColors.primary.withValues(alpha: 0.08 + _controller.value * 0.04),
                AppColors.background,
              ],
            ),
          ),
        );
      },
    );
  }
}
