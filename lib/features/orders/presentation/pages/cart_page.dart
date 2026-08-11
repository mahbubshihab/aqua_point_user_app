import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../bloc/cart_bloc.dart';
import '../../../products/presentation/pages/shop_page.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final itemBoxBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;
    final bottomBarBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColorPrimary,
            size: 20,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'My Cart',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.items.isEmpty) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () {
                  _showClearCartDialog(context, isDark);
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.accentRed,
                  size: 18,
                ),
                label: Text(
                  'Clear All',
                  style: GoogleFonts.inter(
                    color: AppColors.accentRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const Gap(4),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 56,
                        color: textColorSecondary,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'Your Cart is Empty',
                      style: GoogleFonts.outfit(
                        color: textColorPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Looks like you haven\'t added any products to your cart yet.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: textColorSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Gap(24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ShopPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? const Color(0xFF020810) : Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        'Browse Products',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cart Item Count Subtitle
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: accentColor,
                            size: 20,
                          ),
                          const Gap(8),
                          Text(
                            'Cart Items (${cartState.totalItemCount})',
                            style: GoogleFonts.outfit(
                              color: textColorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),

                      // List of Cart Items
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartState.items.length,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return _buildCartItemCard(context, item, isDark);
                        },
                      ),
                      const Gap(24),

                      // Price Summary Card
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            color: accentColor,
                            size: 20,
                          ),
                          const Gap(8),
                          Text(
                            'Price Summary',
                            style: GoogleFonts.outfit(
                              color: textColorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      AppCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: GoogleFonts.inter(
                                    color: textColorSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '৳${cartState.subtotal.toStringAsFixed(0)}',
                                  style: GoogleFonts.inter(
                                    color: textColorPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Fee',
                                  style: GoogleFonts.inter(
                                    color: textColorSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '৳${cartState.shippingFee.toStringAsFixed(0)}',
                                  style: GoogleFonts.inter(
                                    color: textColorPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: borderColor, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: GoogleFonts.inter(
                                    color: textColorPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '৳${cartState.totalAmount.toStringAsFixed(0)}',
                                  style: GoogleFonts.outfit(
                                    color: accentColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                    ],
                  ),
                ),
              ),

              // Bottom Sticky Bar with Proceed to Checkout Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bottomBarBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Amount',
                            style: GoogleFonts.inter(
                              color: textColorSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                          Text(
                            '৳${cartState.totalAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              color: accentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: accentColor,
                            foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                            elevation: 4,
                            shadowColor: accentColor.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceed to Checkout',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: isDark ? const Color(0xFF020810) : Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, bool isDark) {
    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final itemBoxBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: itemBoxBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (item.imageUrl != null && item.imageUrl!.startsWith('http'))
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.water_drop_rounded,
                        color: accentColor,
                        size: 32,
                      ),
                    )
                  : Icon(
                      Icons.water_drop_rounded,
                      color: accentColor,
                      size: 32,
                    ),
            ),
          ),
          const Gap(12),

          // Item Details & Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.inter(
                          color: textColorPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<CartBloc>().add(RemoveFromCart(item.id));
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.accentRed,
                        size: 20,
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
                if (item.warranty != null && item.warranty!.isNotEmpty) ...[
                  const Gap(2),
                  Text(
                    item.warranty!,
                    style: GoogleFonts.inter(
                      color: AppColors.accentGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '৳${item.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        color: accentColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Quantity Controls (+ / -)
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: itemBoxBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<CartBloc>().add(
                                    UpdateQuantity(
                                      itemId: item.id,
                                      quantity: item.quantity - 1,
                                    ),
                                  );
                            },
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.remove,
                                size: 14,
                                color: textColorPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '${item.quantity}',
                              style: GoogleFonts.inter(
                                color: textColorPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.read<CartBloc>().add(
                                    UpdateQuantity(
                                      itemId: item.id,
                                      quantity: item.quantity + 1,
                                    ),
                                  );
                            },
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, bool isDark) {
    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark ? Colors.white60 : const Color(0xFF64748B);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
        title: Text(
          'Clear Cart?',
          style: GoogleFonts.inter(
            color: textColorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: GoogleFonts.inter(
            color: textColorSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: textColorSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CartBloc>().add(const ClearCart());
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
