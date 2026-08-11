import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/checkout_page.dart';
import '../../domain/entities/product_entity.dart';
import '../pages/product_detail_page.dart';

class ShopProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onBuyNow;
  final bool isHorizontal;
  final bool showMinimal;

  const ShopProductCard({
    super.key,
    required this.product,
    this.onBuyNow,
    this.isHorizontal = false,
    this.showMinimal = false,
  });

  void _onAddToCart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cartItem = CartItem(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
      imageUrl: product.photoUrl,
      warranty: product.warrantyDetails,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 20),
            const Gap(10),
            Expanded(
              child: Text(
                '${product.name} added to Cart',
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBuyNowPressed(BuildContext context) {
    if (onBuyNow != null) {
      onBuyNow!();
      return;
    }
    final cartItem = CartItem(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
      imageUrl: product.photoUrl,
      warranty: product.warrantyDetails,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutPage()),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = '৳${product.price.toInt()}';
    final originalPriceStr = product.originalPrice != null ? '৳${product.originalPrice!.toInt()}' : null;

    if (isHorizontal) {
      return Container(
        width: 175,
        margin: const EdgeInsets.only(right: 12),
        child: _buildCardContent(context, priceStr, originalPriceStr, isMinimalView: true),
      );
    }

    return _buildCardContent(context, priceStr, originalPriceStr, isMinimalView: showMinimal);
  }

  Widget _buildCardContent(
    BuildContext context,
    String priceStr,
    String? originalPriceStr, {
    required bool isMinimalView,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final imgBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return AppCard(
      padding: const EdgeInsets.all(10),
      borderRadius: 16,
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image Container
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: imgBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildProductImage(imgBg, accentColor),
              ),
            ),
            const Gap(8),

            // Product Name / Title
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: textColorPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const Gap(4),

            // Warranty Text
            Text(
              product.warrantyDetails,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColors.accentGreen,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(6),

            // Price Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  priceStr,
                  style: GoogleFonts.inter(
                    color: accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isMinimalView && originalPriceStr != null) ...[
                  const Gap(5),
                  Text(
                    originalPriceStr,
                    style: GoogleFonts.inter(
                      color: textColorSecondary,
                      fontSize: 10.5,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),

            // Show Cart & Buy Now action buttons ONLY if NOT in minimal view (e.g. on full Shop catalog page)
            if (!isMinimalView) ...[
              const Gap(10),
              Row(
                children: [
                  // Add to Cart Icon Button
                  Material(
                    color: isDark
                        ? const Color(0xFF00BCE1).withValues(alpha: 0.15)
                        : const Color(0x2000BCE1),
                    borderRadius: BorderRadius.circular(9),
                    child: InkWell(
                      onTap: () => _onAddToCart(context),
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF00BCE1).withValues(alpha: 0.3)
                                : const Color(0x6000BCE1),
                          ),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart_rounded,
                          color: accentColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const Gap(6),
                  // Buy Now Button
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        gradient: isDark
                            ? const LinearGradient(
                                colors: [Color(0xFF0088FF), Color(0xFF00BCE1)],
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF00BCE1), Color(0xFF0089A8)],
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? const Color(0xFF00BCE1).withValues(alpha: 0.35)
                                : const Color(0x4000BCE1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _onBuyNowPressed(context),
                          borderRadius: BorderRadius.circular(9),
                          child: Center(
                            child: Text(
                              'Buy Now',
                              style: GoogleFonts.inter(
                                color: isDark ? const Color(0xFF020810) : Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Color imgBg, Color accentColor) {
    if (product.photoUrl != null && product.photoUrl!.isNotEmpty) {
      if (product.photoUrl!.startsWith('http')) {
        return Image.network(
          product.photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(imgBg, accentColor),
        );
      }
    }
    return _buildFallbackImage(imgBg, accentColor);
  }

  Widget _buildFallbackImage(Color imgBg, Color accentColor) {
    return Container(
      color: imgBg,
      child: Center(
        child: Icon(
          Icons.water_drop_rounded,
          color: accentColor,
          size: 40,
        ),
      ),
    );
  }
}
