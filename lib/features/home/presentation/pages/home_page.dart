import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/help_support_page.dart';
import '../../../profile_rewards/presentation/pages/profile_page.dart';
import '../../../profile_rewards/presentation/pages/reward_points_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/blogs_news_section.dart';
import '../widgets/home_footer_widget.dart';
import '../widgets/home_header_banner.dart';
import '../widgets/hydration_tracker_widget.dart';
import '../widgets/my_products_section.dart';
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
      body: SafeArea(
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
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeaderBanner(
                      onProfileTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfilePage()),
                        );
                      },
                      onPointsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RewardPointsPage()),
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
                                  context.read<HomeBloc>().add(const SelectTab(1));
                                },
                              ),
                              QuickActionItem(
                                label: 'Buy Parts',
                                icon: Icons.shopping_bag_rounded,
                                iconColor: const Color(0xFF10B981),
                                gradientColors: const [Color(0xFF047857), Color(0xFF10B981)],
                                glowColor: const Color(0x5510B981),
                                onTap: () {
                                  context.read<HomeBloc>().add(const SelectTab(2));
                                },
                              ),
                              QuickActionItem(
                                label: 'Invoices',
                                icon: Icons.receipt_long_rounded,
                                iconColor: const Color(0xFFF59E0B),
                                gradientColors: const [Color(0xFFB45309), Color(0xFFF59E0B)],
                                glowColor: const Color(0x55F59E0B),
                                onTap: () {
                                  context.read<HomeBloc>().add(const SelectTab(1));
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
                          const MyProductsSection(),
                          const Gap(14),
                          HydrationTrackerWidget(
                            hydration: state.hydration,
                            onIncrement: () {
                              context.read<HomeBloc>().add(const IncrementHydration());
                            },
                            onDecrement: () {
                              context.read<HomeBloc>().add(const DecrementHydration());
                            },
                          ),
                          const Gap(14),
                          WaterQualityCard(waterQuality: state.waterQuality),
                          const Gap(14),
                          const ServicesGrid(),
                          const Gap(14),
                          BlogsNewsSection(blogs: state.blogs),
                          const Gap(14),
                          HomeFooterWidget(companyInfo: state.companyInfo),
                          const Gap(14),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
