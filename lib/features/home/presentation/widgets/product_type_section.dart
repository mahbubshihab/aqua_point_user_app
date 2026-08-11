import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/pages/category_shop_page.dart';
import '../../../products/presentation/pages/product_detail_page.dart';
import '../../../products/presentation/widgets/shop_product_card.dart';

class ProductTypeSection extends StatefulWidget {
  final String title;
  final String typeTag;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final List<ProductEntity> products;

  const ProductTypeSection({
    super.key,
    required this.title,
    required this.typeTag,
    this.subtitle,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header (Very Minimal: Icon, Title & View All)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.accentColor, size: 22),
                    const Gap(8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.outfit(
                              color: theme.colorScheme.onSurface,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Animated underline indicator
                          AnimatedBuilder(
                            animation: _glowController,
                            builder: (context, child) {
                              return Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 24 + (_glowController.value * 16),
                                decoration: BoxDecoration(
                                  color: widget.accentColor,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              );
                            },
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
                      MaterialPageRoute(builder: (_) => ShopPage()),
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
                        style: GoogleFonts.inter(
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
          const Gap(12),
          // Product List or Minimal Empty State
          if (widget.products.isNotEmpty)
            SizedBox(
              height: 225,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return _AnimatedProductCardWrapper(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: ShopProductCard(
                      product: product,
                      isHorizontal: true,
                    ),
                  );
                },
              ),
            )
          else
            // Minimal Compact Empty State Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isDark ? [] : AppShadows.soft,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 16,
                      color: widget.accentColor,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'No ${widget.title} Available',
                      style: GoogleFonts.inter(
                        color: theme.colorScheme.onSurface,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedProductCardWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _AnimatedProductCardWrapper({
    required this.child,
    this.onTap,
  });

  @override
  State<_AnimatedProductCardWrapper> createState() => _AnimatedProductCardWrapperState();
}

class _AnimatedProductCardWrapperState extends State<_AnimatedProductCardWrapper> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
