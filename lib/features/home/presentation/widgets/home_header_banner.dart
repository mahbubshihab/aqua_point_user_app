import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/theme_provider.dart';
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
    final topPadding = MediaQuery.of(context).padding.top;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Get userId from AuthBloc
    final authState = context.read<AuthBloc>().state;
    String? userId;
    if (authState is Authenticated) {
      userId = authState.userId;
    }

    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF004D40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppGradients.primary,
        ),
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: topPadding + 16.0,
          bottom: 32.0, // extra padding for the curve
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.water_drop_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AQUA POINT',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildGreeting(userId),
                ],
              ),
            ),
            
            // Right: Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeToggle(context, isDarkMode),
                const SizedBox(width: 12),
                _buildProfileAvatar(userId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(String? userId) {
    if (userId == null) {
      return Text(
        'Welcome back!',
        style: GoogleFonts.inter(
          fontSize: 20,
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
            fontSize: 20,
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
        width: 44,
        height: 44,
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
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white),
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
  Widget _buildThemeToggle(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.2),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: child.key == const ValueKey('icon_moon')
                  ? Tween<double>(begin: -0.25, end: 0.0).animate(animation)
                  : Tween<double>(begin: 0.25, end: 0.0).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDarkMode ? 'icon_sun' : 'icon_moon'),
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
