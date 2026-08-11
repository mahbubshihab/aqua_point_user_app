import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../products/presentation/widgets/add_product_modal.dart';

class MyProductsSection extends StatefulWidget {
  final VoidCallback? onViewAllTap;

  const MyProductsSection({
    super.key,
    this.onViewAllTap,
  });

  @override
  State<MyProductsSection> createState() => _MyProductsSectionState();
}

class _MyProductsSectionState extends State<MyProductsSection> {
  String? _resolvedUserId;

  @override
  void initState() {
    super.initState();
    _resolveUserId();
  }

  Future<void> _resolveUserId() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final phone = authState.phoneNumber;
      if (phone.isNotEmpty) {
        setState(() => _resolvedUserId = phone);
        return;
      }
      if (authState.userId.isNotEmpty) {
        setState(() => _resolvedUserId = authState.userId);
        return;
      }
    }

    final localPhone = await AuthLocalDatasource().getUserPhone();
    if (localPhone != null && localPhone.isNotEmpty) {
      setState(() => _resolvedUserId = localPhone);
      return;
    }

    final localUserId = await AuthLocalDatasource().getUserId();
    if (localUserId != null && localUserId.isNotEmpty) {
      setState(() => _resolvedUserId = localUserId);
      return;
    }

    final authUser = FirebaseAuth.instance.currentUser;
    final fallback = authUser?.phoneNumber ?? authUser?.uid ?? 'guest_user';
    setState(() => _resolvedUserId = fallback);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: "My Products" & "+ Add Custom Product"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(8),
                Text(
                  'My Products',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColorPrimary,
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onViewAllTap ??
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductsPage()),
                      );
                    },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: accentColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stream custom products added by the user
        if (_resolvedUserId == null)
          _buildEmptyStateCard(context, isDark)
        else
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('customers')
                .doc(_resolvedUserId)
                .collection('custom_products')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingCard(isDark);
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return _buildEmptyStateCard(context, isDark);
              }

              // Display custom added products in horizontal card slider
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final name = (data['name'] ?? 'Custom Product').toString();
                    final photoUrl = (data['photoUrl'] ?? data['imageUrl']) as String?;

                    return _buildConnectedDeviceCard(
                      context: context,
                      name: name,
                      photoUrl: photoUrl,
                      isDark: isDark,
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLoadingCard(bool isDark) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildConnectedDeviceCard({
    required BuildContext context,
    required String name,
    required String? photoUrl,
    required bool isDark,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0B192C), const Color(0xFF1E3E62)]
              : [const Color(0xFF0F2942), const Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF0284C7) : const Color(0xFF0F2942))
                .withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Status, Device Name & Action
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Connected Device Label
                  Text(
                    'Connected Device',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Gap(6),

                  // Product Name
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const Gap(8),

                  // Water Flow Active Indicator
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        'Water Flow Active',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Gap(16),

            // Right Image Display
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: (photoUrl != null && photoUrl.startsWith('http'))
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImageFallback(),
                      )
                    : _buildImageFallback(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Center(
      child: Icon(
        Icons.water_drop_rounded,
        color: Colors.white.withValues(alpha: 0.9),
        size: 48,
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0B192C), const Color(0xFF1E3E62)]
              : [const Color(0xFF0F2942), const Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF0284C7) : const Color(0xFF0F2942))
                .withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connected Device',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const Gap(6),
                  Text(
                    'No Custom Product Added',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Add your custom water purifier to view it here.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const Gap(12),
                  InkWell(
                    onTap: () {
                      AddProductModal.show(context);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_circle_outline_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const Gap(6),
                          Text(
                            'Add Custom Product',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.water_drop_outlined,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
