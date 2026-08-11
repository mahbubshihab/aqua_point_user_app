import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/pages/product_detail_page.dart';
import '../../../products/presentation/pages/products_page.dart';

class MyProductsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final VoidCallback? onViewAllTap;

  const MyProductsSection({
    super.key,
    this.products = const [],
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final imgBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: "My Products" and "View All ›"
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
                onTap: onViewAllTap ??
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

        if (products.isEmpty)
          // Default / Empty State Card
          _buildDefaultProductCard(context, isDark, cardBgColor, imgBg, borderColor, textColorPrimary, textColorSecondary, accentColor)
        else
          // Horizontal List of User Products
          SizedBox(
            height: 195,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductItemCard(
                  context,
                  product,
                  isDark,
                  cardBgColor,
                  imgBg,
                  borderColor,
                  textColorPrimary,
                  textColorSecondary,
                  accentColor,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultProductCard(
    BuildContext context,
    bool isDark,
    Color cardBgColor,
    Color imgBg,
    Color borderColor,
    Color textColorPrimary,
    Color textColorSecondary,
    Color accentColor,
  ) {
    final demoProduct = const ProductEntity(
      id: 'demo_1',
      name: 'Livotec Open Water Purifier',
      description: 'Advanced 6-stage RO water purification system',
      price: 12500,
      photoUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?w=500&q=80',
      warrantyDetails: '1 Year Warranty • Active',
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductsPage()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: imgBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: accentColor,
                    size: 38,
                  ),
                ),
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'MY DEVICE',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '1 Year Warranty',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),
                  Text(
                    demoProduct.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColorPrimary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Tap to view details & warranty card',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: textColorSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItemCard(
    BuildContext context,
    ProductEntity product,
    bool isDark,
    Color cardBgColor,
    Color imgBg,
    Color borderColor,
    Color textColorPrimary,
    Color textColorSecondary,
    Color accentColor,
  ) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 95,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: imgBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (product.photoUrl != null && product.photoUrl!.startsWith('http'))
                        ? Image.network(
                            product.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.water_drop_rounded,
                                color: accentColor,
                                size: 36,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.water_drop_rounded,
                              color: accentColor,
                              size: 36,
                            ),
                          ),
                  ),
                ),
                const Gap(8),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColorPrimary,
                  ),
                ),
                const Gap(3),
                Text(
                  product.warrantyDetails.isNotEmpty
                      ? product.warrantyDetails
                      : 'Warranty Active',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
