import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../inbox_support/presentation/pages/help_support_page.dart';
import '../../../inbox_support/presentation/pages/refer_win_page.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/profile_rewards_bloc.dart';
import '../bloc/profile_rewards_event.dart';
import '../bloc/profile_rewards_state.dart';
import 'personal_info_page.dart';
import 'reward_points_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isUploadingAvatar = false;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<void> _pickAndUploadAvatar(
      BuildContext context, UserProfileEntity profile) async {
    final bloc = context.read<ProfileRewardsBloc>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isUploadingAvatar = true;
    });

    try {
      const demoPath =
          '/Users/mahbubshihab/Development/AQUA_POINT/demo_files/WhatsApp Image 2026-08-06 at 22.10.25 (1).jpeg';
      final file = File(demoPath);

      String? url;
      if (await file.exists()) {
        url = await _cloudinaryService.uploadImage(file);
      } else {
        final bytes = Uint8List.fromList([
          137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1,
          0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 213, 196, 200, 0, 0, 0, 13, 73, 68, 65, 84,
          120, 156, 99, 96, 248, 15, 0, 1, 5, 1, 2, 210, 221, 143, 203, 0, 0, 0, 0,
          73, 69, 78, 68, 174, 66, 96, 130
        ]);
        url = await _cloudinaryService.uploadImageBytes(
          bytes,
          'avatar_${DateTime.now().millisecondsSinceEpoch}.png',
        );
      }

      if (url != null && mounted) {
        bloc.add(
          UpdateProfile(profile: profile.copyWith(avatarUrl: url)),
        );
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Avatar uploaded & updated via Cloudinary!'),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Avatar upload failed: $e'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingAvatar = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.textPrimary),
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
          UserProfileEntity? userProfile;

          if (state is ProfileRewardsLoaded) {
            userProfile = state.userProfile;
            name = userProfile.name;
            if (name.isNotEmpty) {
              initial = name[0].toUpperCase();
            }
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Center Avatar
                Center(
                  child: GestureDetector(
                    onTap: (_isUploadingAvatar || userProfile == null)
                        ? null
                        : () => _pickAndUploadAvatar(context, userProfile!),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.divider,
                          ),
                          child: CircleAvatar(
                            radius: 38,
                            backgroundColor: AppColors.cardBackground,
                            backgroundImage: (userProfile?.avatarUrl != null &&
                                    userProfile!.avatarUrl.startsWith('http'))
                                ? ResizeImage(NetworkImage(userProfile.avatarUrl), width: 600, height: 600)
                                : null,
                            child: _isUploadingAvatar
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : (userProfile?.avatarUrl != null &&
                                        userProfile!.avatarUrl
                                            .startsWith('http'))
                                    ? null
                                    : Text(
                                        initial,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

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
                      MaterialPageRoute(
                          builder: (_) => const PersonalInfoPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.stars_rounded,
                  iconColor: AppColors.accentYellow,
                  title: 'My Reward Points',
                  subtitle: 'View points history and rewards',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RewardPointsPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  iconColor: const Color(0xFFEC4899),
                  title: 'Help & Support',
                  subtitle: 'FAQs and contact us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HelpSupportPage()),
                    );
                  },
                ),
                const SizedBox(height: 14),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 14),
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
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 14,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isLogout ? AppColors.accentRed : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
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
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to sign out from your account?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary)),
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
