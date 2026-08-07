import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/checkout_page.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  void _onAddToCart(BuildContext context) {
    final cartItem = CartItem(
      id: widget.product.id,
      name: widget.product.name,
      price: widget.product.price,
      quantity: _quantity,
      imageUrl: widget.product.photoUrl,
      warranty: widget.product.warrantyDetails,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.product.name} added to cart!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: const Color(0xFF00E5FF),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CheckoutPage()),
            );
          },
        ),
      ),
    );
  }

  void _onBuyNow(BuildContext context) {
    final cartItem = CartItem(
      id: widget.product.id,
      name: widget.product.name,
      price: widget.product.price,
      quantity: _quantity,
      imageUrl: widget.product.photoUrl,
      warranty: widget.product.warrantyDetails,
    );

    context.read<CartBloc>().add(AddToCart(cartItem));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutPage()),
                      );
                    },
                  ),
                  if (cartState.totalItemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartState.totalItemCount}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Banner Container
                  Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildImage(),
                    ),
                  ),
                  const Gap(20),

                  // Product Title and Price Tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E5FF), Color(0xFF00BCE1)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3300E5FF),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '৳${widget.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),

                  // Warranty & Custom Badges
                  Row(
                    children: [
                      StatBadge.excellent(
                        text: widget.product.warrantyDetails,
                      ),
                      if (widget.product.isCustom) ...[
                        const Gap(8),
                        const StatBadge(
                          text: 'CUSTOM FIT',
                          backgroundColor: Color(0x208B5CF6),
                          textColor: Color(0xFFA78BFA),
                        ),
                      ],
                    ],
                  ),
                  const Gap(20),

                  const Divider(color: AppColors.divider),
                  const Gap(16),

                  // Specifications / Description
                  const Text(
                    'Overview & Specifications',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow(Icons.verified_user_outlined, 'Warranty', widget.product.warrantyDetails),
                        const Divider(color: AppColors.divider, height: 20),
                        _buildFeatureRow(Icons.local_shipping_outlined, 'Delivery', 'Standard Express (৳60)'),
                        const Divider(color: AppColors.divider, height: 20),
                        _buildFeatureRow(Icons.build_circle_outlined, 'Installation', 'Free Expert On-site Setup'),
                        const Divider(color: AppColors.divider, height: 20),
                        _buildFeatureRow(Icons.water_drop_outlined, 'Compatibility', 'Universal 10" Water Systems'),
                      ],
                    ),
                  ),
                  const Gap(24),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Quantity',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              color: AppColors.textPrimary,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xF00D111D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _onAddToCart(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.primary, size: 18),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),

                  // Buy Now Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _onBuyNow(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        elevation: 4,
                        shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.flash_on_rounded, color: Colors.black, size: 18),
                      label: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const Gap(12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (widget.product.photoUrl != null && widget.product.photoUrl!.isNotEmpty) {
      if (widget.product.photoUrl!.startsWith('http')) {
        return Image.network(
          widget.product.photoUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      }
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    return const Center(
      child: Icon(
        Icons.water_drop_rounded,
        size: 80,
        color: AppColors.primary,
      ),
    );
  }
}
