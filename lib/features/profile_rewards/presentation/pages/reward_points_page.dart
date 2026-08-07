import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
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
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.25),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$points',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'TOTAL POINTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFD97706),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(0, 40),
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
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // How to Earn Points? section
                const Text(
                  'How to Earn Points?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 24),

                // Points History section
                const Text(
                  'Points History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.history_toggle_off_rounded,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No points history found',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // FAQ section in Bengali
                const Text(
                  'সচরাচর জিজ্ঞাসিত প্রশ্ন (FAQ)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (faqs.isEmpty) ...[
                  _buildFaqAccordion(
                    question: 'মীম ওয়াটার পয়েন্ট কি?',
                    answer: 'মীম ওয়াটার পয়েন্ট হলো AQUA POINT অ্যাপের একটি রিওয়ার্ড প্রোগ্রাম, যার মাধ্যমে আপনি অ্যাপ ব্যবহার, সেবা গ্রহণ ও রেফারেলের মাধ্যমে পয়েন্ট অর্জন করতে পারবেন।',
                  ),
                  _buildFaqAccordion(
                    question: 'কিভাবে মীম ওয়াটার পয়েন্ট পাওয়ার জন্য বিবেচিত হবো?',
                    answer: 'AQUA POINT অ্যাপে অ্যাকাউন্ট খোলার পর প্রতিটি সেবা গ্রহণ ও ক্রয়ের সাথে সাথে আপনি পয়েন্ট অর্জনের জন্য বিবেচিত হবেন।',
                  ),
                  _buildFaqAccordion(
                    question: 'মীম ওয়াটার পয়েন্ট অর্জন করবো কিভাবে?',
                    answer: 'অ্যাপ ব্যবহার, পণ্য ও সেবা ক্রয়, সার্ভিস সম্পূর্ণকরণ এবং বন্ধুদের রেফার করার মাধ্যমে পয়েন্ট অর্জন করতে পারবেন।',
                  ),
                  _buildFaqAccordion(
                    question: 'শর্ত সমুহ',
                    answer: 'রিওয়ার্ড পয়েন্টসমূহ অন্য কোন অ্যাকাউন্টে হস্তান্তর করা যাবে না এবং নির্দিষ্ট সময়সীমার মধ্যে ব্যবহার করতে হবে।',
                  ),
                ] else ...[
                  ...faqs.map((faq) => _buildFaqAccordion(
                        question: faq.question,
                        answer: faq.answer,
                      )),
                ],
                const SizedBox(height: 20),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accentYellow, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
