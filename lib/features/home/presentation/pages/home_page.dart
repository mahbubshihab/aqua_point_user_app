import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/chat_conversation_page.dart';
import '../../../products/presentation/pages/shop_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';
import '../../../services/presentation/pages/services_history_page.dart';
import '../../../tools/presentation/pages/blogs_news_page.dart';
import '../../../tools/presentation/pages/store_locator_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/blogs_news_section.dart';
import '../widgets/categories_section.dart';

import '../widgets/home_header_banner.dart';
import '../widgets/my_products_section.dart';
import '../widgets/promotional_banners_slider.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/services_grid.dart';
import '../widgets/stores_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
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
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.surface,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
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
                            const Gap(24),
                          ],
                          QuickActionGrid(
                            items: [
                              QuickActionItem(
                                label: 'Request Service',
                                icon: Icons.home_repair_service_rounded,
                                iconColor: const Color(0xFF00B4D8),
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
                                iconColor: AppColors.success,
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
                                iconColor: AppColors.warning,
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
                                iconColor: AppColors.primary,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ChatConversationPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Gap(24),
                          CategoriesSection(categories: state.categories),
                          const Gap(24),
                          MyProductsSection(
                            onViewAllTap: () {
                              context.read<HomeBloc>().add(const SelectTab(2));
                            },
                          ),
                          const Gap(24),
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
                                title: 'Store Locator',
                                description: 'Find nearest Aqua Point branch',
                                icon: Icons.location_on_outlined,
                                color: AppColors.warning,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const StoreLocatorPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Gap(24),
                          const StoresSection(),
                          const Gap(24),
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
                          const Gap(32),
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
    );
  }
}
