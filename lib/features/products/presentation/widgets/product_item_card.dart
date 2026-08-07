import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../domain/entities/product_entity.dart';

class ProductItemCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onOptionsTap;

  const ProductItemCard({
    super.key,
    required this.product,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Photo Thumbnail
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildThumbnail(),
            ),
          ),
          const Gap(14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (product.isCustom) ...[
                      const Gap(6),
                      const StatBadge(
                        text: 'CUSTOM',
                        backgroundColor: Color(0x208B5CF6),
                        textColor: Color(0xFFA78BFA),
                        fontSize: 10,
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      ),
                    ],
                  ],
                ),
                const Gap(6),
                Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: AppColors.accentGreen,
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        product.warrantyDetails,
                        style: const TextStyle(
                          color: AppColors.accentGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(4),
                    Text(
                      'Purchased: ${product.purchaseDate}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Options Menu / Icon
          IconButton(
            onPressed: onOptionsTap ?? () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    if (product.photoUrl != null && product.photoUrl!.isNotEmpty) {
      if (product.photoUrl!.startsWith('http')) {
        return Image.network(
          product.photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        );
      }
    }
    return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    return const Center(
      child: Icon(
        Icons.water_drop_rounded,
        color: AppColors.primary,
        size: 30,
      ),
    );
  }
}
