import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/ai_hydration_tank_card.dart';
import '../widgets/amc_premium_card.dart';
import '../widgets/home_blog_swiper_section.dart';
import '../widgets/home_quick_services.dart';
import '../widgets/ocean_header_banner.dart';
import '../widgets/purifier_status_tech_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FA),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0083B0),
              ),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFEF4444),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0083B0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.read<HomeBloc>().add(const LoadHomeData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final loadedState = state is HomeLoaded ? state : null;

          return RefreshIndicator(
            color: const Color(0xFF0083B0),
            backgroundColor: Colors.white,
            onRefresh: () async {
              context.read<HomeBloc>().add(const LoadHomeData());
              await Future.delayed(const Duration(milliseconds: 600));
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  // 1. Ocean Header Banner
                  OceanHeaderBanner(
                    onMenuTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    onNotificationTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationsPage()),
                      );
                    },
                    onProfileTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                  ),

                  // 2. Main Content Sections Overlapping Header by -40px
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          // 2.1 Compact Pro Tech Card (Purifier Status)
                          const PurifierStatusTechCard(),

                          const SizedBox(height: 24),

                          // 2.2 Quick Services (Request Service Button + 4 Floating Grid Items)
                          const HomeQuickServices(),

                          const SizedBox(height: 24),

                          // 2.3 Premium AMC Care Card
                          const AmcPremiumCard(),

                          const SizedBox(height: 24),

                          // 2.4 AI Health & Hydration Tank Card
                          AiHydrationTankCard(
                            initialLiters: (loadedState?.hydration.currentGlasses ?? 6) * 0.25,
                            goalLiters: (loadedState?.hydration.targetGlasses ?? 10) * 0.25,
                          ),

                          const SizedBox(height: 24),

                          // 2.5 Integrated Swiper Blog Section
                          HomeBlogSwiperSection(
                            blogs: loadedState?.blogs,
                          ),

                          // Bottom spacing for smooth bottom navigation bar clearance
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
