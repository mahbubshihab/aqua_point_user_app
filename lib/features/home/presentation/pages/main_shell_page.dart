import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../inbox_support/presentation/pages/chat_conversation_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../services/presentation/pages/services_history_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'home_page.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final currentIndex = (state is HomeLoaded) ? state.tabIndex : 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F7FA),
          extendBody: true,
          body: IndexedStack(
            index: currentIndex.clamp(0, 3),
            children: const [
              HomePage(),
              ServicesHistoryPage(),
              ChatConversationPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: _WaterBottomNavBar(
            currentIndex: currentIndex,
            onTabSelected: (index) {
              context.read<HomeBloc>().add(SelectTab(index));
            },
            onCallTap: () async {
              final uri = Uri.parse('tel:01780885841');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hotline: 01780885841'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Color(0xFF0083B0),
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}

class _WaterBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCallTap;

  const _WaterBottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
    required this.onCallTap,
  });

  @override
  State<_WaterBottomNavBar> createState() => _WaterBottomNavBarState();
}

class _WaterBottomNavBarState extends State<_WaterBottomNavBar>
    with TickerProviderStateMixin {
  late final AnimationController _fabFloatController;
  late final AnimationController _fabRippleController;

  @override
  void initState() {
    super.initState();
    _fabFloatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fabRippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _fabFloatController.dispose();
    _fabRippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Main Nav Bar Body
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPadding > 0 ? bottomPadding : 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: const Border(
                  top: BorderSide(
                    color: Color(0x3300B4DB),
                    width: 1.5,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140083B0),
                    blurRadius: 40,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 1. Home
                  _NavItem(
                    index: 0,
                    currentIndex: widget.currentIndex,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => widget.onTabSelected(0),
                  ),

                  // 2. Orders
                  _NavItem(
                    index: 1,
                    currentIndex: widget.currentIndex,
                    icon: Icons.format_list_bulleted_rounded,
                    label: 'Orders',
                    onTap: () => widget.onTabSelected(1),
                  ),

                  // 3. Middle placeholder space for Central Floating Water Button
                  const SizedBox(width: 56),

                  // 4. Support
                  _NavItem(
                    index: 2,
                    currentIndex: widget.currentIndex,
                    icon: Icons.chat_bubble_rounded,
                    label: 'Support',
                    onTap: () => widget.onTabSelected(2),
                  ),

                  // 5. Profile
                  _NavItem(
                    index: 3,
                    currentIndex: widget.currentIndex,
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    onTap: () => widget.onTabSelected(3),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Central Floating Water Button
        Positioned(
          top: -24,
          child: _CentralFloatingWaterButton(
            floatController: _fabFloatController,
            rippleController: _fabRippleController,
            onTap: widget.onCallTap,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF00B4DB)
                  : const Color(0xFF9CA3AF),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? const Color(0xFF00B4DB)
                    : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 3),
            // Glowing Cyan Drop Indicator Dot
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: AnimatedScale(
                scale: isActive ? 1.2 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00B4DB),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x8000B4DB),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CentralFloatingWaterButton extends StatefulWidget {
  final AnimationController floatController;
  final AnimationController rippleController;
  final VoidCallback onTap;

  const _CentralFloatingWaterButton({
    required this.floatController,
    required this.rippleController,
    required this.onTap,
  });

  @override
  State<_CentralFloatingWaterButton> createState() =>
      _CentralFloatingWaterButtonState();
}

class _CentralFloatingWaterButtonState
    extends State<_CentralFloatingWaterButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.floatController,
      builder: (context, child) {
        final offsetY =
            math.sin(widget.floatController.value * 2 * math.pi) * 3.5;
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulsing Ripple Pulse Aura Ring
                AnimatedBuilder(
                  animation: widget.rippleController,
                  builder: (context, child) {
                    final progress = widget.rippleController.value;
                    final scale = 1.0 + progress * 0.45;
                    final opacity = (1.0 - progress) * 0.6;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00B4DB)
                                .withValues(alpha: opacity.clamp(0.0, 1.0)),
                            width: 2.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Main Central Floating Water FAB
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: const Color(0xFFF0F7FA),
                      width: 3.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x6600B4DB),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.phone_rounded,
                      color: Colors.white,
                      size: 22,
                      shadows: [
                        Shadow(
                          color: Color(0x40000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
