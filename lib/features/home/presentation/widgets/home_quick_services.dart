import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../products/presentation/pages/category_shop_page.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../services/presentation/pages/create_service_request_page.dart';
import '../../../services/presentation/pages/services_history_page.dart';

class HomeQuickServices extends StatefulWidget {
  final VoidCallback? onRequestServiceTap;
  final VoidCallback? onFiltersTap;
  final VoidCallback? onPartsTap;
  final VoidCallback? onShopTap;
  final VoidCallback? onHistoryTap;

  const HomeQuickServices({
    super.key,
    this.onRequestServiceTap,
    this.onFiltersTap,
    this.onPartsTap,
    this.onShopTap,
    this.onHistoryTap,
  });

  @override
  State<HomeQuickServices> createState() => _HomeQuickServicesState();
}

class _HomeQuickServicesState extends State<HomeQuickServices>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width Liquid Request Service Button
        _LiquidRequestButton(
          onTap: widget.onRequestServiceTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateServiceRequestPage(),
                  ),
                );
              },
          controller: _floatController,
        ),

        const SizedBox(height: 24),

        // Section Title
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'QUICK SERVICES',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF005C97),
              letterSpacing: 1.0,
            ),
          ),
        ),

        // 4 Floating Action Cards Grid/Row
        Row(
          children: [
            // 1. Filters
            Expanded(
              child: _FloatServiceItem(
                controller: _floatController,
                phaseDelay: 0.0,
                icon: Icons.tune_rounded,
                title: 'FILTERS',
                onTap: widget.onFiltersTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryShopPage(
                            categoryName: 'Water Filters',
                            categoryId: 'water_filter',
                          ),
                        ),
                      );
                    },
              ),
            ),
            const SizedBox(width: 10),

            // 2. Parts
            Expanded(
              child: _FloatServiceItem(
                controller: _floatController,
                phaseDelay: 0.2,
                icon: Icons.settings_suggest_rounded,
                title: 'PARTS',
                onTap: widget.onPartsTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryShopPage(
                            categoryName: 'Parts & Accessories',
                            categoryId: 'filter_accessories',
                          ),
                        ),
                      );
                    },
              ),
            ),
            const SizedBox(width: 10),

            // 3. Shop
            Expanded(
              child: _FloatServiceItem(
                controller: _floatController,
                phaseDelay: 0.4,
                icon: Icons.shopping_bag_outlined,
                title: 'SHOP',
                onTap: widget.onShopTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductsPage(),
                        ),
                      );
                    },
              ),
            ),
            const SizedBox(width: 10),

            // 4. History
            Expanded(
              child: _FloatServiceItem(
                controller: _floatController,
                phaseDelay: 0.6,
                icon: Icons.assignment_outlined,
                title: 'HISTORY',
                onTap: widget.onHistoryTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ServicesHistoryPage(),
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LiquidRequestButton extends StatefulWidget {
  final VoidCallback onTap;
  final AnimationController controller;

  const _LiquidRequestButton({
    required this.onTap,
    required this.controller,
  });

  @override
  State<_LiquidRequestButton> createState() => _LiquidRequestButtonState();
}

class _LiquidRequestButtonState extends State<_LiquidRequestButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0083B0), Color(0xFF00B4DB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00B4DB).withValues(alpha: _isPressed ? 0.20 : 0.35),
                blurRadius: _isPressed ? 12 : 20,
                offset: Offset(0, _isPressed ? 4 : 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Animated Floating Headset Icon Container
                  AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, child) {
                      final offsetY = math.sin(widget.controller.value * 2 * math.pi) * 3.0;
                      return Transform.translate(
                        offset: Offset(0, offsetY),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.headset_mic_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Text Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'QUICK RESOLUTION',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDBEAFE),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Request Service',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Right Arrow Icon
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatServiceItem extends StatefulWidget {
  final AnimationController controller;
  final double phaseDelay;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FloatServiceItem({
    required this.controller,
    required this.phaseDelay,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<_FloatServiceItem> createState() => _FloatServiceItemState();
}

class _FloatServiceItemState extends State<_FloatServiceItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final progress = (widget.controller.value + widget.phaseDelay) % 1.0;
        final offsetY = math.sin(progress * 2 * math.pi) * 3.5;

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
          scale: _isPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFF1F5F9),
                width: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D005C97),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  color: const Color(0xFF00B4DB),
                  size: 22,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B7280),
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
