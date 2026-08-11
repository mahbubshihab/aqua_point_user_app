import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/animated_theme_toggle_button.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

class HomeHeaderBanner extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const HomeHeaderBanner({
    super.key,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Get userId from AuthBloc
    final authState = context.read<AuthBloc>().state;
    String? userId;
    if (authState is Authenticated) {
      userId = authState.userId;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF0284C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppGradients.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: topPadding + 10.0,
        bottom: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Greeting & Brand
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        height: 18,
                        width: 18,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.water_drop_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AQUA POINT',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildGreeting(userId),
              ],
            ),
          ),
          
          // Right: Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedThemeToggleButton(showLabel: false),
              const SizedBox(width: 10),
              _buildProfileAvatar(userId),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(String? userId) {
    if (userId == null) {
      return Text(
        'Welcome back!',
        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('customers').doc(userId).get(),
      builder: (context, snapshot) {
        String name = 'Welcome back!';
        
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data.containsKey('name') && data['name'] != null && data['name'].toString().isNotEmpty) {
            // Get first name
            name = 'Hi, ${data['name'].toString().split(' ')[0]}';
          }
        }

        return Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  Widget _buildProfileAvatar(String? userId) {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.2),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: userId == null
            ? const Icon(Icons.person, color: Colors.white)
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('customers').doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    if (data.containsKey('avatarUrl') && data['avatarUrl'] != null && data['avatarUrl'].toString().isNotEmpty) {
                      return ClipOval(
                        child: Image.network(
                          data['avatarUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white),
                        ),
                      );
                    }
                  }
                  return const Icon(Icons.person, color: Colors.white);
                },
              ),
      ),
    );
  }
}

