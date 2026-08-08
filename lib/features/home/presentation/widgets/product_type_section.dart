import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/pages/category_shop_page.dart';
import '../../../products/presentation/pages/shop_page.dart';
import '../../../products/presentation/widgets/shop_product_card.dart';

class ProductTypeSection extends StatefulWidget {
  final String title;
  final String typeTag;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<ProductEntity> products;

  const ProductTypeSection({
    super.key,
    required this.title,
    required this.typeTag,
    required this.subtitle,
    required this.icon,
    this.accentColor = AppColors.primary,
    required this.products,
  });

  @override
  State<ProductTypeSection> createState() => _ProductTypeSectionState();
}

class _ProductTypeSectionState extends State<ProductTypeSection> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      final glow = _glowController.value;
                      return Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: widget.accentColor,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: widget.accentColor.withValues(alpha: 0.3 + glow * 0.4),
                              blurRadius: 4 + glow * 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  const Gap(8),
                  Icon(widget.icon, color: widget.accentColor, size: 18),
                  const Gap(6),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Animated underline
                        AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            return Container(
                              margin: const EdgeInsets.only(top: 2),
                              height: 1.5,
                              width: 30 + (_glowController.value * 20),
                              decoration: BoxDecoration(
                                color: widget.accentColor.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(1),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.accentColor.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.products.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryShopPage(
                        categoryName: widget.title,
                        products: widget.products,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ShopPage()),
                  );
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: widget.accentColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(2),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: widget.accentColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(4),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            widget.subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Gap(12),
        // Product List or Empty State
        if (widget.products.isNotEmpty)
          SizedBox(
            height: 235,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return _AnimatedProductCardWrapper(
                  child: ShopProductCard(
                    product: product,
                    isHorizontal: true,
                  ),
                );
              },
            ),
          )
        else
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            borderRadius: 16,
            borderColor: widget.accentColor.withValues(alpha: 0.25),
            fillColor: const Color(0x1F1A2236),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: widget.accentColor,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No ${widget.title} available',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        'Server query filter: type == ${widget.typeTag}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AnimatedProductCardWrapper extends StatefulWidget {
  final Widget child;
  const _AnimatedProductCardWrapper({required this.child});

  @override
  State<_AnimatedProductCardWrapper> createState() => _AnimatedProductCardWrapperState();
}

class _AnimatedProductCardWrapperState extends State<_AnimatedProductCardWrapper> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
