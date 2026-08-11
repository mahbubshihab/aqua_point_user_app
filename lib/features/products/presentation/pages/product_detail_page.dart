import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/cart_page.dart';
import '../../../orders/presentation/pages/checkout_page.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/product_reviews_section.dart';

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
  late PageController _pageController;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAddToCart(BuildContext context) {
    final theme = Theme.of(context);
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
                style: GoogleFonts.inter(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.surface,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: const Color(0xFF00E5FF),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final images = widget.product.allImages;
    final specSections = widget.product.specSections;
    final features = widget.product.features;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product Details',
          style: GoogleFonts.outfit(
            color: theme.colorScheme.onSurface,
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
                    icon: Icon(Icons.shopping_cart_outlined, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                  ),
                  if (cartState.totalItemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartState.totalItemCount}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
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
                  // Product Swipeable Gallery Container
                  _buildGallerySection(images, theme, isDark),
                  const Gap(20),

                  // Product Title and Price Tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: GoogleFonts.outfit(
                            color: theme.colorScheme.onSurface,
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
                            colors: [Color(0xFF00E5FF), Color(0xFF0088FF)],
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
                          style: GoogleFonts.outfit(
                            color: Colors.white,
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

                  Divider(color: isDark ? AppColors.darkDivider : AppColors.divider),
                  const Gap(16),

                  // Dynamic Specification Tables (From Firestore)
                  if (specSections.isNotEmpty) ...[
                    ...specSections.map((sec) => _buildSpecTableSection(sec, theme, isDark)),
                  ] else ...[
                    // Legacy Fallback Table
                    _buildLegacyOverviewSection(theme, isDark),
                  ],

                  // Product Features / Bullet Points Section
                  if (features.isNotEmpty) ...[
                    const Gap(24),
                    _buildFeaturesSection(features, theme, isDark),
                  ],

                  // Overview Description Text
                  if (widget.product.description != null && widget.product.description!.isNotEmpty) ...[
                    const Gap(24),
                    Text(
                      'Overview',
                      style: GoogleFonts.outfit(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      child: Text(
                        widget.product.description!,
                        style: GoogleFonts.inter(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  const Gap(24),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Quantity',
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove_rounded, size: 18),
                              color: theme.colorScheme.onSurface,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '$_quantity',
                                style: GoogleFonts.outfit(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add_rounded, size: 18),
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  Divider(color: isDark ? AppColors.darkDivider : AppColors.divider),
                  const Gap(20),

                  // Customer Reviews & Submission Section
                  ProductReviewsSection(product: widget.product),
                  const Gap(30),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
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
                        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.add_shopping_cart_rounded, color: theme.colorScheme.primary, size: 18),
                      label: Text(
                        'Add to Cart',
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.primary,
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
                        backgroundColor: theme.colorScheme.primary,
                        elevation: 4,
                        shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 18),
                      label: Text(
                        'Buy Now',
                        style: GoogleFonts.inter(
                          color: Colors.white,
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

  /// Builds a dynamic specification table matching the website screenshot style!
  Widget _buildSpecTableSection(SpecSectionEntity sec, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFB0E2FF),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header Bar (Solid Aqua/Blue header like screenshot)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0091EA), Color(0xFF00BCE1)],
                ),
              ),
              child: Text(
                sec.title.toUpperCase(),
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            // Rows Table
            Column(
              children: List.generate(sec.items.length, (index) {
                final item = sec.items[index];
                final isEven = index % 2 == 0;
                final rowBg = isEven
                    ? (isDark ? AppColors.darkSurfaceVariant.withValues(alpha: 0.3) : const Color(0xFFF4FBFF))
                    : theme.colorScheme.surface;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: rowBg,
                    border: index < sec.items.length - 1
                        ? Border(
                            bottom: BorderSide(
                              color: isDark ? AppColors.darkDivider : const Color(0xFFE1F5FE),
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Label / Key Cell
                      SizedBox(
                        width: 140,
                        child: Text(
                          '${item.label} :',
                          style: GoogleFonts.inter(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Value Cell
                      Expanded(
                        child: Text(
                          item.value,
                          style: GoogleFonts.inter(
                            color: theme.colorScheme.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds features bullet points section ("PRODUCT DESCRIPTION")
  Widget _buildFeaturesSection(List<String> features, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Text(
                'PRODUCT DESCRIPTION',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0091EA),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCE1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFF00BCE1).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features.map((ft) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_box_rounded,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ft,
                        style: GoogleFonts.inter(
                          color: theme.colorScheme.onSurface,
                          fontSize: 12,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegacyOverviewSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview & Specifications',
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Column(
            children: [
              _buildFeatureRow(Icons.verified_user_outlined, 'Warranty', widget.product.warrantyDetails, theme),
              Divider(color: isDark ? AppColors.darkDivider : AppColors.divider, height: 20),
              _buildFeatureRow(Icons.local_shipping_outlined, 'Delivery', 'Standard Express (৳60)', theme),
              Divider(color: isDark ? AppColors.darkDivider : AppColors.divider, height: 20),
              _buildFeatureRow(Icons.build_circle_outlined, 'Installation', 'Free Expert On-site Setup', theme),
              Divider(color: isDark ? AppColors.darkDivider : AppColors.divider, height: 20),
              _buildFeatureRow(Icons.water_drop_outlined, 'Compatibility', 'Universal 10" Water Systems', theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGallerySection(List<String> images, ThemeData theme, bool isDark) {
    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 260,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: _buildFallback(theme),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PageView.builder(
                  key: PageStorageKey<String>('product_gallery_${widget.product.id}'),
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final imgUrl = images[index];
                    if (imgUrl.startsWith('http')) {
                      return Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
                      );
                    }
                    return _buildFallback(theme);
                  },
                ),
              ),
              if (images.length > 1) ...[
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_selectedImageIndex + 1}/${images.length}',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _selectedImageIndex == index ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _selectedImageIndex == index
                              ? theme.colorScheme.primary
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (images.length > 1) ...[
          const Gap(12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: images.length,
              separatorBuilder: (context, index) => const Gap(10),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedImageIndex;
                final imgUrl = images[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : (isDark ? AppColors.darkBorder : AppColors.border),
                        width: isSelected ? 2.5 : 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imgUrl.startsWith('http')
                          ? Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
                            )
                          : _buildFallback(theme),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const Gap(12),
        Text(
          title,
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFallback(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.water_drop_rounded,
        size: 80,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
