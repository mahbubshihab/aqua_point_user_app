import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../cart_manager.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CartBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartManager.instance,
      builder: (context, _) {
        final cart = CartManager.instance;
        final items = cart.items;

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppColors.primary, width: 1.5)),
          ),
          child: Column(
            children: [
              const Gap(12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(14),
              // Title bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 24),
                    const Gap(10),
                    const Text(
                      'Shopping Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${cart.totalItemCount} items',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.divider),
              // Cart Item List
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                            const Gap(12),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(6),
                            const Text(
                              'Add water purifiers or filters to get started',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final product = item.product;

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: (product.photoUrl != null && product.photoUrl!.startsWith('http'))
                                        ? Image.network(product.photoUrl!, fit: BoxFit.cover)
                                        : const Icon(Icons.water_drop_rounded, color: AppColors.primary),
                                  ),
                                ),
                                const Gap(12),
                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Gap(4),
                                      Text(
                                        '৳${product.price.toInt()}',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Quantity selector
                                Row(
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        cart.updateQuantity(product, item.quantity - 1);
                                      },
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white60, size: 20),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        cart.updateQuantity(product, item.quantity + 1);
                                      },
                                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              // Footer grand total & Checkout
              if (items.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    border: Border(top: BorderSide(color: AppColors.divider)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total:',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '৳${cart.grandTotal.toInt()}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Gap(14),
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
                              Navigator.pop(context);
                              cart.clearCart();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AppColors.accentGreen,
                                  content: Text(
                                    '🎉 Checkout complete! Thank you for ordering from Aqua Point.',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Text(
                              'Proceed to Checkout',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
