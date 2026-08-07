import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final _nameController = TextEditingController(text: 'Shihab Hossain');
  final _phoneController = TextEditingController(text: '01712345678');
  final _addressController = TextEditingController(
    text: 'House 12, Road 4, Sector 7, Uttara, Dhaka',
  );
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

    final orderData = {
      'orderId': orderId,
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
      // Fallback logging for offline / unauthenticated Firestore rules fallback
      debugPrint('Firestore order write error (handled gracefully): $e');
    }

    if (!mounted) return;

    // Trigger ServicesBloc reload so Orders tab updates immediately
    try {
      context.read<ServicesBloc>().add(const LoadServicesHistory());
    } catch (_) {}

    // Clear cart
    context.read<CartBloc>().add(const ClearCart());

    setState(() {
      _isSubmitting = false;
    });

    // Navigate to OrderConfirmationPage
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
          'Checkout',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
                        color: AppColors.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Gap(20),
                    const Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(6),
                    const Text(
                      'Add water purifiers or replacement filters to proceed with checkout.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
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
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.water_drop_outlined, color: Colors.black),
                      label: const Text(
                        'Explore Products',
                        style: TextStyle(
                          color: Colors.black,
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
                        // Section 1: Customer Shipping & Contact Information
                        _buildSectionHeader('Shipping & Contact Info', Icons.location_on_outlined),
                        const Gap(10),
                        AppCard(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                decoration: const InputDecoration(
                                  labelText: 'Full Name *',
                                  hintText: 'Enter recipient name',
                                  prefixIcon: Icon(Icons.person_outline, size: 20),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(12),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number *',
                                  hintText: '017XXXXXXXX',
                                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
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
                              TextFormField(
                                controller: _addressController,
                                maxLines: 2,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                decoration: const InputDecoration(
                                  labelText: 'Delivery Address *',
                                  hintText: 'House no, Road, Area, District',
                                  prefixIcon: Icon(Icons.home_outlined, size: 20),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter complete delivery address';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(12),
                              TextFormField(
                                controller: _instructionsController,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                decoration: const InputDecoration(
                                  labelText: 'Delivery Instructions (Optional)',
                                  hintText: 'e.g. Leave with security guard, call before delivery',
                                  prefixIcon: Icon(Icons.note_alt_outlined, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),

                        // Section 2: Order Items Breakdown List
                        _buildSectionHeader('Order Items (${cartState.totalItemCount})', Icons.shopping_bag_outlined),
                        const Gap(10),
                        AppCard(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartState.items.length,
                            separatorBuilder: (context, index) => const Divider(color: AppColors.divider, height: 20),
                            itemBuilder: (context, index) {
                              final item = cartState.items[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.inputFill,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.divider),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: (item.imageUrl != null && item.imageUrl!.startsWith('http'))
                                          ? Image.network(
                                              item.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => const Icon(
                                                Icons.water_drop_rounded,
                                                color: AppColors.primary,
                                                size: 24,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.water_drop_rounded,
                                              color: AppColors.primary,
                                              size: 24,
                                            ),
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Gap(2),
                                        Text(
                                          '৳${item.price.toStringAsFixed(0)} each',
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Quantity Selector (+ / -) & Trash
                                  Row(
                                    children: [
                                      Container(
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColors.inputFill,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.divider),
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
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Icon(Icons.remove, size: 14, color: AppColors.textPrimary),
                                              ),
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                color: AppColors.textPrimary,
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
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: Icon(Icons.add, size: 14, color: AppColors.primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Gap(4),
                                      IconButton(
                                        onPressed: () {
                                          context.read<CartBloc>().add(RemoveFromCart(item.id));
                                        },
                                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.accentRed, size: 18),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(6),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const Gap(20),

                        // Section 3: Payment Method Selector
                        _buildSectionHeader('Payment Method', Icons.account_balance_wallet_outlined),
                        const Gap(10),
                        AppCard(
                          child: Column(
                            children: [
                              _buildPaymentTile(
                                title: 'Cash on Delivery (COD)',
                                subtitle: 'Pay in cash when order arrives at your address',
                                value: 'Cash on Delivery',
                                icon: Icons.payments_outlined,
                                badgeColor: AppColors.accentGreen,
                              ),
                              const Divider(color: AppColors.divider, height: 16),
                              _buildPaymentTile(
                                title: 'bKash Mobile Banking',
                                subtitle: 'Instant digital wallet payment',
                                value: 'bKash',
                                icon: Icons.account_balance_wallet_outlined,
                                badgeColor: const Color(0xFFE2136E),
                              ),
                              const Divider(color: AppColors.divider, height: 16),
                              _buildPaymentTile(
                                title: 'Nagad Digital Payment',
                                subtitle: 'Fast and secure payment via Nagad',
                                value: 'Nagad',
                                icon: Icons.phone_android_outlined,
                                badgeColor: const Color(0xFFF7921E),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),

                        // Section 4: Price Summary
                        _buildSectionHeader('Price Breakdown', Icons.receipt_long_outlined),
                        const Gap(10),
                        AppCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                                  Text(
                                    '৳${cartState.subtotal.toStringAsFixed(0)}',
                                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Shipping Fee (Fixed)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
                                  Text(
                                    '৳${cartState.shippingFee.toStringAsFixed(0)}',
                                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Divider(color: AppColors.divider, height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '৳${cartState.totalAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: AppColors.primary,
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

                // Bottom Sticky Bar & "Confirm Order" Button
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Total Payable',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                            Text(
                              '৳${cartState.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppColors.primary,
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
                              backgroundColor: AppColors.primary,
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Confirm Order',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Gap(6),
                                      Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 18),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const Gap(8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color badgeColor,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: badgeColor, size: 20),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
