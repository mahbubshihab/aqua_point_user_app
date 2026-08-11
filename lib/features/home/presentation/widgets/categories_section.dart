import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../products/domain/entities/category_entity.dart';
import '../../../products/presentation/pages/category_shop_page.dart';
import '../../../products/presentation/pages/shop_page.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoriesSection({
    super.key,
    required this.categories,
  });

  static const List<CategoryEntity> _defaultCategories = [
    CategoryEntity(id: 'cat_ro', name: 'RO Purifiers'),
    CategoryEntity(id: 'cat_filter', name: 'Filters & Cartridges'),
    CategoryEntity(id: 'cat_parts', name: 'Spare Parts'),
    CategoryEntity(id: 'cat_service', name: 'Services'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayCategories = categories.isNotEmpty ? categories : _defaultCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: GoogleFonts.outfit(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: GoogleFonts.inter(
                        color: theme.colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final category = displayCategories[index];
              return _CategoryCard(category: category);
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final CategoryEntity category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;

  IconData _getCategoryFallbackIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('purifier') || lowerName.contains('ro')) return Icons.water_drop_rounded;
    if (lowerName.contains('filter') || lowerName.contains('cartridge')) return Icons.filter_alt_rounded;
    if (lowerName.contains('part') || lowerName.contains('spare') || lowerName.contains('fitting')) return Icons.build_rounded;
    if (lowerName.contains('softener') || lowerName.contains('plant')) return Icons.invert_colors_rounded;
    if (lowerName.contains('service') || lowerName.contains('maintenance')) return Icons.home_repair_service_rounded;
    if (lowerName.contains('dispenser') || lowerName.contains('tap')) return Icons.local_drink_rounded;
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final category = widget.category;
    final bool hasImage = category.imageUrl != null && category.imageUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryShopPage(
                  categoryName: category.name,
                  products: const [],
                ),
              ),
            );
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark ? [] : AppShadows.soft,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: hasImage
                        ? Image.network(
                            category.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                _getCategoryFallbackIcon(category.name),
                                color: theme.colorScheme.primary,
                                size: 24,
                              );
                            },
                          )
                        : Icon(
                            _getCategoryFallbackIcon(category.name),
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                  ),
                ),
                const Gap(8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
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
