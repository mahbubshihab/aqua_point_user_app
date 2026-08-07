import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/checkout_page.dart';
import '../../domain/entities/product_entity.dart';
import '../pages/product_detail_page.dart';

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

  void _onAddToCart(BuildContext context) {
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
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        child: _buildCardContent(context, priceStr, originalPriceStr),
      );
    }

    return _buildCardContent(context, priceStr, originalPriceStr);
  }

  Widget _buildCardContent(BuildContext context, String priceStr, String? originalPriceStr) {
    return GlassCard(
      padding: const EdgeInsets.all(10),
      borderRadius: 16,
      fillColor: const Color(0xB31E293B),
      borderWidth: 1.0,
      borderColor: const Color(0x80334155),
      borderGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x5000BCE1),
          Color(0x40334155),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tapping image / title section opens ProductDetailPage
          GestureDetector(
            onTap: () => _navigateToDetail(context),
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image preview container
                Stack(
                  children: [
                    Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0x800F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildProductImage(),
                      ),
                    ),
                    if (product.rating != null)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xCC0F172A),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0x6000BCE1), width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 12),
                              const Gap(2),
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (product.originalPrice != null) ...[
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${(((product.originalPrice! - product.price) / product.originalPrice!) * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap(8),
                // Title
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const Gap(3),
                // Category tag or warranty details
                Text(
                  product.warrantyDetails,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.accentGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(6),
                // Price section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      priceStr,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (originalPriceStr != null) ...[
                      const Gap(5),
                      Text(
                        originalPriceStr,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Gap(8),
          // Action Buttons: Add to Cart & Buy Now
          Row(
            children: [
              // Add to Cart Icon Button
              Material(
                color: const Color(0x2000BCE1),
                borderRadius: BorderRadius.circular(9),
                child: InkWell(
                  onTap: () => _onAddToCart(context),
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0x6000BCE1)),
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: AppColors.primary,
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BCE1), Color(0xFF0089A8)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4000BCE1),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onBuyNowPressed(context),
                      borderRadius: BorderRadius.circular(9),
                      child: const Center(
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
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
}
