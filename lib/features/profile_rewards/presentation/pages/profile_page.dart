import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../inbox_support/presentation/pages/help_support_page.dart';
import '../../../inbox_support/presentation/pages/refer_win_page.dart';
import '../bloc/profile_rewards_bloc.dart';
import '../bloc/profile_rewards_event.dart';
import '../bloc/profile_rewards_state.dart';
import 'personal_info_page.dart';
import 'reward_points_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          'Account',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings tapped')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileRewardsBloc, ProfileRewardsState>(
        builder: (context, state) {
          String name = 'Customer';
          String initial = 'C';

          if (state is ProfileRewardsLoaded) {
            name = state.userProfile.name;
            if (name.isNotEmpty) {
              initial = name[0].toUpperCase();
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Center Avatar
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.divider,
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.cardBackground,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 28),

                // Menu items list
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  iconColor: AppColors.primary,
                  title: 'Personal Info',
                  subtitle: 'Name, Phone, Address',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PersonalInfoPage()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  context,
                  icon: Icons.stars_rounded,
                  iconColor: AppColors.accentYellow,
                  title: 'My Reward Points',
                  subtitle: 'View points history and rewards',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardPointsPage()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  context,
                  icon: Icons.card_giftcard_outlined,
                  iconColor: const Color(0xFF10B981),
                  title: 'Refer & Win',
                  subtitle: 'Earn points by inviting friends',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReferWinPage()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  iconColor: const Color(0xFFEC4899),
                  title: 'Help & Support',
                  subtitle: 'FAQs and contact us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 16),
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.accentRed,
                  title: 'Logout',
                  subtitle: 'Sign out from your account',
                  isLogout: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLogout ? AppColors.accentRed : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            'Logout',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to sign out from your account?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(100, 40),
              ),
              onPressed: () {
                context.read<ProfileRewardsBloc>().add(const LogoutUser());
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully logged out')),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
