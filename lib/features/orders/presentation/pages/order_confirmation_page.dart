import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../home/presentation/pages/main_shell_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/bloc/services_event.dart';
import '../../../services/presentation/pages/services_history_page.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;
  final String orderDate;
  final String paymentMethod;
  final String customerName;
  final String phone;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
    required this.orderDate,
    required this.paymentMethod,
    required this.customerName,
    required this.phone,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _navigateToHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Order Confirmed',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Gap(12),
              // Success Animated Checkmark Banner
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0x2010B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF10B981), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3310B981),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 56,
                    ),
                  ),
                ),
              ),
              const Gap(16),
              const Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(6),
              const Text(
                'Thank you for your purchase. We are preparing your shipment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const Gap(24),

              // Order Summary Reference Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order ID',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          orderId,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date & Time',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          orderDate,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        StatBadge.excellent(
                          text: paymentMethod,
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const StatBadge(
                          text: 'PENDING',
                          backgroundColor: Color(0x20F59E0B),
                          textColor: Color(0xFFF59E0B),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Customer & Delivery Info Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
                        Gap(8),
                        Text(
                          'Shipping Address',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      customerName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      phone,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      deliveryAddress,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    if (deliveryInstructions != null && deliveryInstructions!.isNotEmpty) ...[
                      const Gap(8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Note: $deliveryInstructions',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(16),

              // Items Breakdown Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 18),
                        Gap(8),
                        Text(
                          'Purchased Items',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    ...items.map((item) {
                      final String name = item['name'] ?? 'Purifier Component';
                      final int qty = (item['quantity'] as num?)?.toInt() ?? 1;
                      final double price = (item['price'] as num?)?.toDouble() ?? 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              'x$qty',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const Gap(12),
                            Text(
                              '৳${(price * qty).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(color: AppColors.divider, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                        Text(
                          '৳${subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5),
                        ),
                      ],
                    ),
                    const Gap(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shipping Fee',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                        Text(
                          '৳${shippingFee.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12.5),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Paid / Due',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '৳${totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(30),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToTrackOrder(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.local_shipping_rounded, color: Colors.black),
                  label: const Text(
                    'Track Order Status',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _navigateToHome(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.home_rounded, color: AppColors.textPrimary),
                  label: const Text(
                    'Back to Home',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTrackOrder(BuildContext context) {
    try {
      context.read<ServicesBloc>().add(const LoadServicesHistory());
    } catch (_) {}

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ServicesBloc>(),
          child: const ServicesHistoryPage(initialTabIndex: 1),
        ),
      ),
      (route) => route.isFirst,
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShellPage()),
      (route) => false,
    );
  }
}
