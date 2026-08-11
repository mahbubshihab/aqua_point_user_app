import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/rain_and_waves_background.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../tools/presentation/pages/blogs_news_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/blogs_news_section.dart';
import '../widgets/categories_section.dart';
import '../widgets/home_header_banner.dart';
import '../widgets/my_products_section.dart';
import '../widgets/product_type_section.dart';
import '../widgets/promotional_banners_slider.dart';
import '../widgets/quick_action_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _startAnimations = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _startAnimations = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RainAndWavesBackground(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
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
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
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
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surface,
                onRefresh: () async {
                  context.read<HomeBloc>().add(const LoadHomeData());
                  await Future.delayed(const Duration(milliseconds: 600));
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header Banner (with smooth theme toggle)
                      HomeHeaderBanner(
                        onProfileTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfilePage()),
                          );
                        },
                      ),
                      const Gap(14),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Promotional Banners (from database, 5s auto-scroll)
                            if (state.banners.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 0),
                                child: PromotionalBannersSlider(
                                  banners: state.banners,
                                ),
                              ),

                            if (state.banners.isNotEmpty) const Gap(16),

                            // 3. Quick Action Cards (Book Service, Shop, Water Reminder, Support)
                            _AnimatedSection(
                              animate: _startAnimations,
                              delay: const Duration(milliseconds: 50),
                              child: const QuickActionGrid(),
                            ),

                            const Gap(24),

                            // 4. Dedicated My Products Section (displays product image & name) right under Quick Actions!
                            _AnimatedSection(
                              animate: _startAnimations,
                              delay: const Duration(milliseconds: 100),
                              child: const MyProductsSection(),
                            ),

                            const Gap(24),

                            // 5. Categories
                            if (state.categories.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 150),
                                child: CategoriesSection(
                                  categories: state.categories,
                                ),
                              ),

                            if (state.categories.isNotEmpty) const Gap(24),

                            // 6. Product Type Sections
                            if (state.openTypeProducts.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 200),
                                child: ProductTypeSection(
                                  title: 'Open Type Purifiers',
                                  typeTag: 'open',
                                  subtitle: 'Traditional open-top water purifiers',
                                  icon: Icons.water_drop_rounded,
                                  accentColor: AppColors.primary,
                                  products: state.openTypeProducts,
                                ),
                              ),

                            if (state.openTypeProducts.isNotEmpty) const Gap(24),

                            if (state.boxTypeProducts.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 300),
                                child: ProductTypeSection(
                                  title: 'Box Type Purifiers',
                                  typeTag: 'box',
                                  subtitle: 'Compact box-style water purifiers',
                                  icon: Icons.inventory_2_rounded,
                                  accentColor: AppColors.secondary,
                                  products: state.boxTypeProducts,
                                ),
                              ),

                            if (state.boxTypeProducts.isNotEmpty) const Gap(24),

                            if (state.hotColdNormalProducts.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 400),
                                child: ProductTypeSection(
                                  title: 'Hot Cold Normal',
                                  typeTag: 'hot_cold_normal',
                                  subtitle: 'Multi-temperature water dispensers',
                                  icon: Icons.thermostat_rounded,
                                  accentColor: AppColors.actionOrange,
                                  products: state.hotColdNormalProducts,
                                ),
                              ),

                            if (state.hotColdNormalProducts.isNotEmpty) const Gap(24),

                            if (state.cabinetTypeProducts.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 500),
                                child: ProductTypeSection(
                                  title: 'Cabinet Type',
                                  typeTag: 'cabinet',
                                  subtitle: 'Premium cabinet-style purifiers',
                                  icon: Icons.kitchen_rounded,
                                  accentColor: AppColors.actionPurple,
                                  products: state.cabinetTypeProducts,
                                ),
                              ),

                            if (state.cabinetTypeProducts.isNotEmpty) const Gap(24),

                            // 7. Blogs & News (at the bottom)
                            if (state.blogs.isNotEmpty)
                              _AnimatedSection(
                                animate: _startAnimations,
                                delay: const Duration(milliseconds: 600),
                                child: BlogsNewsSection(
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
                              ),

                            // 8. Bottom Padding
                            const Gap(100),
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
    );
  }
}

/// Animated section wrapper with staggered fade-in and smooth slide-up
class _AnimatedSection extends StatelessWidget {
  final bool animate;
  final Duration delay;
  final Widget child;

  const _AnimatedSection({
    required this.animate,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: animate ? 1.0 : 0.0),
      duration: Duration(milliseconds: 650 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
