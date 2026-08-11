import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/cart_page.dart';
import '../../../orders/presentation/pages/checkout_page.dart';
import '../../domain/entities/product_entity.dart';
import '../pages/product_detail_page.dart';

class ProductItemCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onOptionsTap;

  const ProductItemCard({
    super.key,
    required this.product,
    this.onOptionsTap,
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

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${product.name} added to cart!',
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.down,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: const Color(0xFF00BCE1),
          onPressed: () {
            messenger.hideCurrentSnackBar();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      messenger.hideCurrentSnackBar();
    });
  }

  void _onBuyNow(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final thumbBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Thumbnail
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: thumbBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildThumbnail(accentColor),
                  ),
                ),
                const Gap(14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.inter(
                                color: textColorPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (product.isCustom) ...[
                            const Gap(6),
                            const StatBadge(
                              text: 'CUSTOM',
                              backgroundColor: Color(0x208B5CF6),
                              textColor: Color(0xFFA78BFA),
                              fontSize: 9,
                              padding:
                                  EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            ),
                          ],
                        ],
                      ),
                      const Gap(4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '৳${product.price.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              color: accentColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.originalPrice != null &&
                              product.originalPrice! > product.price) ...[
                            const Gap(6),
                            Text(
                              '৳${product.originalPrice!.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                color: textColorSecondary,
                                fontSize: 11.5,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 13,
                            color: AppColors.accentGreen,
                          ),
                          const Gap(4),
                          Expanded(
                            child: Text(
                              product.warrantyDetails,
                              style: GoogleFonts.inter(
                                color: AppColors.accentGreen,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
          Divider(color: borderColor, height: 1),
          const Gap(10),

          // Functional Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: () => _onAddToCart(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      side: BorderSide(color: accentColor, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: accentColor,
                      size: 15,
                    ),
                    label: Text(
                      'Add to Cart',
                      style: GoogleFonts.inter(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () => _onBuyNow(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: accentColor,
                      foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(
                      Icons.flash_on_rounded,
                      color: isDark ? const Color(0xFF020810) : Colors.white,
                      size: 15,
                    ),
                    label: Text(
                      'Buy Now',
                      style: GoogleFonts.inter(
                        color: isDark ? const Color(0xFF020810) : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(Color fallbackColor) {
    if (product.photoUrl != null && product.photoUrl!.isNotEmpty) {
      if (product.photoUrl!.startsWith('http')) {
        return Image.network(
          product.photoUrl!,
          fit: BoxFit.cover,
          cacheWidth: 600,
          cacheHeight: 600,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(fallbackColor),
        );
      }
    }
    return _buildFallbackIcon(fallbackColor);
  }

  Widget _buildFallbackIcon(Color fallbackColor) {
    return Center(
      child: Icon(
        Icons.water_drop_rounded,
        color: fallbackColor,
        size: 30,
      ),
    );
  }
}
