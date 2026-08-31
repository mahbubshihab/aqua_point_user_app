import 'dart:math' as math;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  void _showContactModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (modalContext) => const _ContactSupportModalSheet(),
    );
  }

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
            onCallTap: () => _showContactModal(context),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
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
                  : const Color(0xFF64748B),
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
                    : const Color(0xFF64748B),
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

class _ContactSupportModalSheet extends StatelessWidget {
  const _ContactSupportModalSheet();

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 30,
                offset: Offset(0, -8),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            math.max(bottomPadding + 16, 28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle Capsule
              Center(
                child: Container(
                  width: 40,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Row with Title & Close button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B4DB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00B4DB).withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.headset_mic_rounded,
                      color: Color(0xFF0083B0),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Support',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'We are here to assist you anytime',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dynamic Firestore Query Body
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('settings')
                    .doc('company_info')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF00B4DB),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Connecting to support channels...',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      !snapshot.data!.exists ||
                      snapshot.data!.data() == null) {
                    return _buildUnconfiguredState();
                  }

                  final data = snapshot.data!.data()!;
                  final phone1 = (data['phone1'] as String?)?.trim() ?? '';
                  final whatsappNumber =
                      (data['whatsappNumber'] as String?)?.trim() ??
                          (data['whatsapp'] as String?)?.trim() ??
                          '';

                  if (phone1.isEmpty && whatsappNumber.isEmpty) {
                    return _buildUnconfiguredState();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. Direct Phone Call Option
                      if (phone1.isNotEmpty)
                        _ContactOptionCard(
                          title: 'Direct Phone Call',
                          subtitle: phone1,
                          badgeText: 'CALL',
                          badgeColor: const Color(0xFF0083B0),
                          gradientColors: const [
                            Color(0xFF0083B0),
                            Color(0xFF00B4DB),
                          ],
                          iconWidget: const Icon(
                            Icons.phone_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                            final cleanPhone =
                                phone1.replaceAll(RegExp(r'[^\d+]'), '');
                            final uri = Uri.parse('tel:$cleanPhone');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Hotline: $phone1'),
                                    backgroundColor: const Color(0xFF0083B0),
                                  ),
                                );
                              }
                            }
                          },
                        ),

                      if (phone1.isNotEmpty && whatsappNumber.isNotEmpty)
                        const SizedBox(height: 12),

                      // 2. WhatsApp Support Option
                      if (whatsappNumber.isNotEmpty)
                        _ContactOptionCard(
                          title: 'WhatsApp Chat',
                          subtitle: whatsappNumber,
                          badgeText: 'WHATSAPP',
                          badgeColor: const Color(0xFF25D366),
                          gradientColors: const [
                            Color(0xFF25D366),
                            Color(0xFF128C7E),
                          ],
                          iconWidget: SvgPicture.string(
                            '''<svg viewBox="0 0 24 24" fill="white" xmlns="http://www.w3.org/2000/svg">
                            <path d="M.057 24l1.687-6.163c-1.041-1.804-1.588-3.849-1.587-5.946.003-6.556 5.338-11.891 11.893-11.891 3.181.001 6.167 1.24 8.413 3.488 2.245 2.248 3.481 5.236 3.48 8.414-.003 6.557-5.338 11.892-11.893 11.892-1.99-.001-3.951-.5-5.688-1.448l-6.305 1.654zm6.597-3.807c1.676.995 3.276 1.591 5.392 1.592 5.448 0 9.886-4.434 9.889-9.885.002-5.462-4.415-9.89-9.881-9.892-5.452 0-9.887 4.434-9.889 9.884-.001 2.225.651 3.891 1.746 5.634l-.999 3.648 3.742-.981zm11.387-5.464c-.074-.124-.272-.198-.57-.347-.297-.149-1.758-.868-2.031-.967-.272-.099-.47-.149-.669.149-.198.297-.768.967-.941 1.165-.173.198-.347.223-.644.074-.297-.149-1.255-.462-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.297-.347.446-.521.151-.172.2-.296.3-.495.099-.198.05-.372-.025-.521-.075-.148-.669-1.611-.916-2.206-.242-.579-.487-.501-.669-.51l-.57-.01c-.198 0-.52.074-.792.372s-1.04 1.016-1.04 2.479 1.065 2.876 1.213 3.074c.149.198 2.095 3.2 5.076 4.487.709.306 1.263.489 1.694.626.712.226 1.36.194 1.872.118.571-.085 1.758-.719 2.006-1.413.248-.695.248-1.29.173-1.414z"/>
                            </svg>''',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                            var clean = whatsappNumber.replaceAll(
                                RegExp(r'[\s\+\-\(\)]'), '');
                            if (clean.startsWith('01') && clean.length == 11) {
                              clean = '88$clean';
                            }
                            final waUri = Uri.parse('https://wa.me/$clean');
                            if (await canLaunchUrl(waUri)) {
                              await launchUrl(
                                waUri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              final appUri =
                                  Uri.parse('whatsapp://send?phone=$clean');
                              if (await canLaunchUrl(appUri)) {
                                await launchUrl(
                                  appUri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'WhatsApp: $whatsappNumber'),
                                      backgroundColor: const Color(0xFF25D366),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnconfiguredState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF1F5F9),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              size: 32,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Support contact numbers have not been configured yet',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please check back later or reach out via in-app chat.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final List<Color> gradientColors;
  final Widget iconWidget;
  final VoidCallback onTap;

  const _ContactOptionCard({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.gradientColors,
    required this.iconWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: gradientColors.first.withValues(alpha: 0.1),
        highlightColor: gradientColors.first.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon Circle with Gradient & Aura
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.last.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(child: iconWidget),
              ),
              const SizedBox(width: 14),

              // Title and Subtitle Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Arrow indicator
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

