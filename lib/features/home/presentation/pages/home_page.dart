import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/blogs_news_section.dart';
import '../widgets/home_header_banner.dart';
import '../widgets/hydration_tracker_widget.dart';
import '../widgets/my_products_section.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner
                    const HomeHeaderBanner(),
                    const SizedBox(height: 20),

                    // Quick Action Buttons (4 round square buttons)
                    const QuickActionGrid(),
                    const SizedBox(height: 24),

                    // My Products Section
                    const MyProductsSection(),
                    const SizedBox(height: 24),

                    // Hydration Tracker Widget
                    HydrationTrackerWidget(
                      hydration: state.hydration,
                      onIncrement: () {
                        context.read<HomeBloc>().add(const IncrementHydration());
                      },
                      onDecrement: () {
                        context.read<HomeBloc>().add(const DecrementHydration());
                      },
                    ),
                    const SizedBox(height: 24),

                    // Water Quality Card
                    WaterQualityCard(waterQuality: state.waterQuality),
                    const SizedBox(height: 24),

                    // Services Grid
                    const ServicesGrid(),
                    const SizedBox(height: 24),

                    // Blogs & News Section
                    BlogsNewsSection(blogs: state.blogs),
                    const SizedBox(height: 32),

                    // Footer
                    const Center(
                      child: Text(
                        'Crafted With ❤️ by AQUA POINT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
