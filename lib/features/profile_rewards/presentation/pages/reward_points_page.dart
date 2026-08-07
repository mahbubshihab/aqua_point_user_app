import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../inbox_support/presentation/pages/refer_win_page.dart';
import '../bloc/profile_rewards_bloc.dart';
import '../bloc/profile_rewards_event.dart';
import '../bloc/profile_rewards_state.dart';
import '../../domain/entities/faq_entity.dart';
import '../../domain/entities/reward_rule_entity.dart';

class RewardPointsPage extends StatelessWidget {
  const RewardPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Reward Points',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: BlocBuilder<ProfileRewardsBloc, ProfileRewardsState>(
        builder: (context, state) {
          int points = 0;
          List<RewardRuleEntity> rules = [];
          List<FaqEntity> faqs = [];

          if (state is ProfileRewardsLoaded) {
            points = state.userProfile.totalPoints;
            rules = state.rewardRules;
            faqs = state.faqs;
          } else if (state is ProfileRewardsInitial) {
            context.read<ProfileRewardsBloc>().add(const LoadProfileData());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bright yellow gradient banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF59E0B),
                        Color(0xFFFBBF24),
                        Color(0xFFF59E0B),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.25),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$points',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'TOTAL POINTS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFD97706),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(0, 36),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ReferWinPage()),
                          );
                        },
                        child: const Text(
                          'Earn More Points',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // How to Earn Points? section
                const Text(
                  'How to Earn Points?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                if (rules.isEmpty) ...[
                  _buildRuleCard(
                    title: 'App Usage',
                    description: 'Earn 1 reward point for every 10 minutes you spend using the app.',
                    icon: Icons.timer_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildRuleCard(
                    title: 'Purchase & Invoices',
                    description: 'Earn 5 reward points for every 100 Taka spent on products or services.',
                    icon: Icons.shopping_bag_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildRuleCard(
                    title: 'Service Completion',
                    description: 'Get 10 reward points for every service successfully completed.',
                    icon: Icons.build_circle_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildRuleCard(
                    title: 'Refer a Friend',
                    description: 'Get 50 points when a friend joins using your referral link.',
                    icon: Icons.card_giftcard_outlined,
                  ),
                ] else ...[
                  ...rules.map((rule) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildRuleCard(
                        title: rule.title,
                        description: rule.description,
                        icon: _getIconData(rule.iconName),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 20),

                // Points History section
                const Text(
                  'Points History',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  borderRadius: 14,
                  child: const Column(
                    children: [
                      Icon(
                        Icons.history_toggle_off_rounded,
                        size: 38,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No points history found',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // FAQ section in English
                const Text(
                  'Frequently Asked Questions (FAQ)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                if (faqs.isEmpty) ...[
                  _buildFaqAccordion(
                    question: 'What are Aqua Point Points?',
                    answer: 'Aqua Point Points is a reward program in the AQUA POINT app where you can earn points through app usage, receiving services, and referring friends.',
                  ),
                  _buildFaqAccordion(
                    question: 'How do I qualify for Aqua Point Points?',
                    answer: 'After creating an account on the AQUA POINT app, you qualify to earn reward points with every service request and purchase.',
                  ),
                  _buildFaqAccordion(
                    question: 'How can I earn points?',
                    answer: 'You can earn points by using the app, purchasing products & services, completing service requests, and referring friends.',
                  ),
                  _buildFaqAccordion(
                    question: 'Terms & Conditions',
                    answer: 'Reward points cannot be transferred to another account and must be redeemed within the valid period.',
                  ),
                ] else ...[
                  ...faqs.map((faq) => _buildFaqAccordion(
                        question: faq.question,
                        answer: faq.answer,
                      )),
                ],
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'timer_outlined':
        return Icons.timer_outlined;
      case 'shopping_bag_outlined':
        return Icons.shopping_bag_outlined;
      case 'build_circle_outlined':
        return Icons.build_circle_outlined;
      case 'card_giftcard_outlined':
        return Icons.card_giftcard_outlined;
      default:
        return Icons.stars_rounded;
    }
  }

  Widget _buildRuleCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accentYellow, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqAccordion({
    required String question,
    required String answer,
  }) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      borderRadius: 14,
      child: Theme(
        data: ThemeData.dark().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
