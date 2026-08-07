import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/product_entity.dart';
import '../cart_manager.dart';

class ShopProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onBuyNow;
  final bool isHorizontal;

  const ShopProductCard({
    super.key,
    required this.product,
    this.onBuyNow,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final priceStr = '৳${product.price.toInt()}';
    final originalPriceStr = product.originalPrice != null ? '৳${product.originalPrice!.toInt()}' : null;

    if (isHorizontal) {
      return Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        child: _buildCardContent(context, priceStr, originalPriceStr),
      );
    }

    return _buildCardContent(context, priceStr, originalPriceStr);
  }

  Widget _buildCardContent(BuildContext context, String priceStr, String? originalPriceStr) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      fillColor: const Color(0x1F141A2D),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withValues(alpha: 0.2),
          AppColors.divider,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image preview container
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildProductImage(),
                ),
              ),
              if (product.rating != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.4), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                        const Gap(3),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (product.originalPrice != null) ...[
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-${(((product.originalPrice! - product.price) / product.originalPrice!) * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const Gap(10),
          // Title
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const Gap(4),
          // Category tag or warranty details
          Text(
            product.warrantyDetails,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.accentGreen,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          // Price section
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                priceStr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (originalPriceStr != null) ...[
                const Gap(6),
                Text(
                  originalPriceStr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const Gap(10),
          // Action Buttons: Add to Cart & Buy Now
          Row(
            children: [
              // Add to Cart Icon Button
              Material(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    CartManager.instance.addToCart(product);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.cardBackground,
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 20),
                            const Gap(10),
                            Expanded(
                              child: Text(
                                '${product.name} added to Cart',
                                style: const TextStyle(color: Colors.white, fontSize: 13),
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
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const Gap(8),
              // Buy Now Button
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF00A3FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onBuyNow ??
                          () {
                            CartManager.instance.addToCart(product);
                            _showCheckoutBottomSheet(context, product);
                          },
                      borderRadius: BorderRadius.circular(10),
                      child: const Center(
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
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
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.photoUrl != null && product.photoUrl!.isNotEmpty) {
      if (product.photoUrl!.startsWith('http')) {
        return Image.network(
          product.photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
        );
      }
    }
    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.cardBackground,
      child: const Center(
        child: Icon(
          Icons.water_drop_rounded,
          color: AppColors.primary,
          size: 40,
        ),
      ),
    );
  }

  void _showCheckoutBottomSheet(BuildContext context, ProductEntity product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppColors.primary, width: 1.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(16),
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                  const Gap(10),
                  const Text(
                    'Instant Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: Colors.white60),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider),
              const Gap(10),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildProductImage(),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          product.warrantyDetails,
                          style: const TextStyle(
                            color: AppColors.accentGreen,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '৳${product.price.toInt()}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, color: AppColors.accentGold, size: 20),
                    Gap(10),
                    Text(
                      'Free Standard Delivery & Installation',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    CartManager.instance.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.accentGreen,
                        content: Text(
                          '🎉 Order placed successfully! Our team will contact you shortly.',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text(
                    'Confirm & Place Order',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }
}
