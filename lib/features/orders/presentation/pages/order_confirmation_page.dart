import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/pages/main_shell_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/bloc/services_event.dart';

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
    const bgColor = AppColors.background;
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const dividerColor = Color(0xFFE2E8F0);
    const accentColor = AppColors.primary;
    const noteBgColor = Color(0xFFF8FAFC);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _navigateToHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Order Confirmed',
            style: GoogleFonts.outfit(
              color: textColorPrimary,
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
              Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: textColorPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(6),
              Text(
                'Thank you for your purchase. We are preparing your shipment.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: textColorSecondary,
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
                        Text(
                          'Order ID',
                          style: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          orderId,
                          style: GoogleFonts.inter(
                            color: accentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: dividerColor, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date & Time',
                          style: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          orderDate,
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: dividerColor, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Method',
                          style: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        StatBadge(
                          text: paymentMethod,
                          backgroundColor: AppColors.successLight,
                          textColor: AppColors.success,
                          icon: Icons.check_circle_rounded,
                        ),
                      ],
                    ),
                    const Divider(color: dividerColor, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const StatBadge(
                          text: 'PENDING',
                          backgroundColor: AppColors.warningLight,
                          textColor: AppColors.warning,
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
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: accentColor, size: 18),
                        const Gap(8),
                        Text(
                          'Shipping Address',
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      customerName,
                      style: GoogleFonts.inter(
                        color: textColorPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      phone,
                      style: GoogleFonts.inter(
                        color: textColorSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      deliveryAddress,
                      style: GoogleFonts.inter(
                        color: textColorSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    if (deliveryInstructions != null && deliveryInstructions!.isNotEmpty) ...[
                      const Gap(8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: noteBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Note: $deliveryInstructions',
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
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
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined, color: accentColor, size: 18),
                        const Gap(8),
                        Text(
                          'Purchased Items',
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
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
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.inter(
                                  color: textColorPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              'x$qty',
                              style: GoogleFonts.inter(
                                color: textColorSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const Gap(12),
                            Text(
                              '৳${(price * qty).toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                color: textColorPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Divider(color: dividerColor, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: GoogleFonts.inter(color: textColorSecondary, fontSize: 12.5),
                        ),
                        Text(
                          '৳${subtotal.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(color: textColorPrimary, fontSize: 12.5),
                        ),
                      ],
                    ),
                    const Gap(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping Fee',
                          style: GoogleFonts.inter(color: textColorSecondary, fontSize: 12.5),
                        ),
                        Text(
                          shippingFee == 0 ? 'Free' : '৳${shippingFee.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: shippingFee == 0 ? AppColors.accentGreen : textColorPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Paid / Due',
                          style: GoogleFonts.inter(
                            color: textColorPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '৳${totalAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.outfit(
                            color: accentColor,
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
                    backgroundColor: accentColor,
                    elevation: 4,
                    shadowColor: accentColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.local_shipping_rounded, color: Colors.white),
                  label: Text(
                    'Track Order Status',
                    style: GoogleFonts.inter(
                      color: Colors.white,
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
                    side: BorderSide(color: dividerColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.home_rounded, color: textColorPrimary),
                  label: Text(
                    'Back to Home',
                    style: GoogleFonts.inter(
                      color: textColorPrimary,
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
    final servicesBloc = context.read<ServicesBloc>();
    final homeBloc = context.read<HomeBloc>();

    servicesBloc.add(const LoadServicesHistory());
    servicesBloc.add(const SelectHistoryTab(1));
    homeBloc.add(const SelectTab(1));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShellPage()),
      (route) => false,
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
