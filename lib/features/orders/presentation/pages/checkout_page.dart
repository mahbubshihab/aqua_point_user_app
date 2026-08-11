import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../home/presentation/pages/main_shell_page.dart';
import '../../../services/presentation/bloc/services_bloc.dart';
import '../../../services/presentation/bloc/services_event.dart';
import '../bloc/cart_bloc.dart';
import 'order_confirmation_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder(CartState cartState) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (cartState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty! Please add items before checkout.'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final randomIdNumber = 10000 + Random().nextInt(89999);
    final orderId = 'AQ-$randomIdNumber';
    final now = DateTime.now();
    final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(now);

    final itemsPayload = cartState.items.map((item) => item.toMap()).toList();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

    final orderData = {
      'orderId': orderId,
      'userId': userId,
      'customerName': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'deliveryInstructions': _instructionsController.text.trim(),
      'paymentMethod': _selectedPaymentMethod,
      'items': itemsPayload,
      'subtotal': cartState.subtotal,
      'shippingFee': cartState.shippingFee,
      'totalAmount': cartState.totalAmount,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'date': dateStr,
    };

    try {
      await FirebaseFirestore.instance.collection('orders').add(orderData);
    } catch (e) {
      debugPrint('Firestore order write error (handled gracefully): $e');
    }

    if (!mounted) return;

    try {
      context.read<ServicesBloc>().add(const LoadServicesHistory());
    } catch (_) {}

    context.read<CartBloc>().add(const ClearCart());

    setState(() {
      _isSubmitting = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationPage(
          orderId: orderId,
          orderDate: dateStr,
          paymentMethod: _selectedPaymentMethod,
          customerName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          deliveryAddress: _addressController.text.trim(),
          deliveryInstructions: _instructionsController.text.trim(),
          items: itemsPayload,
          subtotal: cartState.subtotal,
          shippingFee: cartState.shippingFee,
          totalAmount: cartState.totalAmount,
        ),
      ),
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
          'Checkout',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                        size: 48,
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
                    const Gap(6),
                    Text(
                      'Add water purifiers or replacement filters to proceed with checkout.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: textColorSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Gap(24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MainShellPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.water_drop_outlined,
                        color: isDark ? const Color(0xFF020810) : Colors.white,
                      ),
                      label: Text(
                        'Explore Products',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Customer Shipping Details
                        _buildSectionHeader('Shipping Details', Icons.location_on_outlined, textColorPrimary, accentColor),
                        const Gap(10),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(6),
                              TextFormField(
                                controller: _nameController,
                                style: GoogleFonts.inter(color: textColorPrimary, fontSize: 14),
                                decoration: _buildInputDecoration(
                                  hintText: 'Enter your full name',
                                  prefixIcon: Icons.person_outline_rounded,
                                  isDark: isDark,
                                  accentColor: accentColor,
                                  borderColor: borderColor,
                                  textColorSecondary: textColorSecondary,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(12),
                              Text(
                                'Phone Number',
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(6),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.inter(color: textColorPrimary, fontSize: 14),
                                decoration: _buildInputDecoration(
                                  hintText: '01XXXXXXXXX',
                                  prefixIcon: Icons.phone_outlined,
                                  isDark: isDark,
                                  accentColor: accentColor,
                                  borderColor: borderColor,
                                  textColorSecondary: textColorSecondary,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  if (value.trim().length < 11) {
                                    return 'Please enter a valid 11-digit mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(12),
                              Text(
                                'Delivery Address',
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(6),
                              TextFormField(
                                controller: _addressController,
                                maxLines: 2,
                                style: GoogleFonts.inter(color: textColorPrimary, fontSize: 14),
                                decoration: _buildInputDecoration(
                                  hintText: 'House, Road, Area, City',
                                  prefixIcon: Icons.home_outlined,
                                  isDark: isDark,
                                  accentColor: accentColor,
                                  borderColor: borderColor,
                                  textColorSecondary: textColorSecondary,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter complete delivery address';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(12),
                              Text(
                                'Instructions (Optional)',
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(6),
                              TextFormField(
                                controller: _instructionsController,
                                style: GoogleFonts.inter(color: textColorPrimary, fontSize: 14),
                                decoration: _buildInputDecoration(
                                  hintText: 'Special delivery instructions',
                                  prefixIcon: Icons.note_alt_outlined,
                                  isDark: isDark,
                                  accentColor: accentColor,
                                  borderColor: borderColor,
                                  textColorSecondary: textColorSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),

                        // Section 2: Order Items Breakdown List
                        _buildSectionHeader('Items (${cartState.totalItemCount})', Icons.shopping_bag_outlined, textColorPrimary, accentColor),
                        const Gap(10),
                        AppCard(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartState.items.length,
                            separatorBuilder: (context, index) => Divider(color: borderColor, height: 20),
                            itemBuilder: (context, index) {
                              final item = cartState.items[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: itemBoxBg,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: (item.imageUrl != null && item.imageUrl!.startsWith('http'))
                                          ? Image.network(
                                              item.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(
                                                Icons.water_drop_rounded,
                                                color: accentColor,
                                                size: 22,
                                              ),
                                            )
                                          : Icon(
                                              Icons.water_drop_rounded,
                                              color: accentColor,
                                              size: 22,
                                            ),
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: GoogleFonts.inter(
                                        color: textColorPrimary,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Gap(8),

                                  // Compact Quantity Controls (- 1 +)
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
                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Icon(Icons.remove, size: 14, color: textColorPrimary),
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: GoogleFonts.inter(
                                            color: textColorPrimary,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
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
                                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Icon(Icons.add, size: 14, color: accentColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(12),
                                  Text(
                                    '৳${NumberFormat('#,##0').format(item.price * item.quantity)}',
                                    style: GoogleFonts.inter(
                                      color: accentColor,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const Gap(20),

                        // Section 3: Payment Method Selection
                        _buildSectionHeader('Payment Method', Icons.payments_outlined, textColorPrimary, accentColor),
                        const Gap(10),
                        AppCard(
                          child: _buildPaymentOption(
                            title: 'Cash on Delivery',
                            icon: Icons.local_shipping_outlined,
                            value: 'Cash on Delivery',
                            isDark: isDark,
                            textColorPrimary: textColorPrimary,
                            textColorSecondary: textColorSecondary,
                            accentColor: accentColor,
                            borderColor: borderColor,
                          ),
                        ),
                        const Gap(20),

                        // Section 4: Summary Breakdown
                        _buildSectionHeader('Summary', Icons.receipt_long_outlined, textColorPrimary, accentColor),
                        const Gap(10),
                        AppCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: GoogleFonts.inter(color: textColorSecondary, fontSize: 13.5),
                                  ),
                                  Text(
                                    '৳${NumberFormat('#,##0').format(cartState.subtotal)}',
                                    style: GoogleFonts.inter(color: textColorPrimary, fontSize: 13.5, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery',
                                    style: GoogleFonts.inter(color: textColorSecondary, fontSize: 13.5),
                                  ),
                                  Text(
                                    cartState.shippingFee == 0
                                        ? 'Free'
                                        : '৳${NumberFormat('#,##0').format(cartState.shippingFee)}',
                                    style: GoogleFonts.inter(
                                      color: cartState.shippingFee == 0 ? AppColors.accentGreen : textColorPrimary,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: borderColor, height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: GoogleFonts.inter(
                                      color: textColorPrimary,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '৳${NumberFormat('#,##0').format(cartState.totalAmount)}',
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
                        const Gap(30),
                      ],
                    ),
                  ),
                ),

                // Bottom Sticky Bar & "Place Order" Button
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
                              'Total',
                              style: GoogleFonts.inter(
                                color: textColorSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                            Text(
                              '৳${NumberFormat('#,##0').format(cartState.totalAmount)}',
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
                            onPressed: _isSubmitting ? null : () => _submitOrder(cartState),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: accentColor,
                              foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                              elevation: 2,
                              shadowColor: accentColor.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: isDark ? const Color(0xFF020810) : Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Place Order',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
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
            ),
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    required bool isDark,
    required Color accentColor,
    required Color borderColor,
    required Color textColorSecondary,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        color: textColorSecondary.withValues(alpha: 0.6),
        fontSize: 13,
      ),
      prefixIcon: Icon(prefixIcon, size: 18, color: accentColor),
      filled: true,
      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.accentRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.accentRed, width: 1.5),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor, Color accentColor) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 18),
        const Gap(8),
        Text(
          title,
          style: GoogleFonts.outfit(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
    required bool isDark,
    required Color textColorPrimary,
    required Color textColorSecondary,
    required Color accentColor,
    required Color borderColor,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.08)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? accentColor : borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? accentColor : textColorSecondary,
              size: 20,
            ),
            const Gap(10),
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: isSelected ? textColorPrimary : textColorSecondary,
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  if (isSelected) ...[
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Selected',
                        style: GoogleFonts.inter(
                          color: accentColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? accentColor : borderColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
