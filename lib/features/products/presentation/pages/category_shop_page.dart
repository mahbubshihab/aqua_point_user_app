import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/cart_page.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/shop_product_card.dart';
import 'shop_page.dart';

class CategoryShopPage extends StatefulWidget {
  final String categoryName;
  final String? categoryId;
  final List<ProductEntity>? products;

  const CategoryShopPage({
    super.key,
    required this.categoryName,
    this.categoryId,
    this.products,
  });

  @override
  State<CategoryShopPage> createState() => _CategoryShopPageState();
}

class _CategoryShopPageState extends State<CategoryShopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'Featured';

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProductsBloc>();
    if (bloc.state is ProductsInitial) {
      bloc.add(const LoadProducts());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductEntity> _filterByCategory(List<ProductEntity> allProducts) {
    final nameLower = widget.categoryName.toLowerCase().trim();
    final idLower = (widget.categoryId ?? '').toLowerCase().trim();

    return allProducts.where((p) {
      final pCategory = (p.category ?? '').toLowerCase().trim();
      final pType = (p.type ?? '').toLowerCase().trim();
      final pName = p.name.toLowerCase().trim();
      final pDesc = (p.description ?? '').toLowerCase().trim();

      // 1. Direct or partial match on category or categoryId
      if (pCategory.isNotEmpty) {
        if (pCategory == nameLower || (idLower.isNotEmpty && pCategory == idLower)) {
          return true;
        }
        if (pCategory.contains(nameLower) || nameLower.contains(pCategory)) {
          return true;
        }
      }

      // 2. Direct or partial match on type
      if (pType.isNotEmpty) {
        if (pType == nameLower || (idLower.isNotEmpty && pType == idLower)) {
          return true;
        }
        if (pType.contains(nameLower) || nameLower.contains(pType)) {
          return true;
        }
      }

      // 3. Keyword / Category matching for common water purifier terms (RO, Filter, Spares, Services, etc.)
      if (nameLower.contains('ro') || idLower.contains('ro') || nameLower.contains('purifier')) {
        if (pType.contains('ro') ||
            pCategory.contains('ro') ||
            pType.contains('open') ||
            pType.contains('box') ||
            pType.contains('cabinet') ||
            pType.contains('purifier') ||
            pCategory.contains('purifier') ||
            pName.contains('ro') ||
            pName.contains('purifier')) {
          return true;
        }
      }

      if (nameLower.contains('filter') || idLower.contains('filter') || nameLower.contains('cartridge')) {
        if (pCategory.contains('filter') ||
            pType.contains('filter') ||
            pName.contains('filter') ||
            pName.contains('cartridge') ||
            pDesc.contains('filter') ||
            pDesc.contains('cartridge')) {
          return true;
        }
      }

      if (nameLower.contains('spare') || idLower.contains('spare') || nameLower.contains('part') || idLower.contains('part')) {
        if (pCategory.contains('spare') ||
            pCategory.contains('part') ||
            pType.contains('spare') ||
            pType.contains('part') ||
            pName.contains('spare') ||
            pName.contains('part') ||
            pName.contains('fitting') ||
            pDesc.contains('spare') ||
            pDesc.contains('part')) {
          return true;
        }
      }

      if (nameLower.contains('service') || idLower.contains('service') || nameLower.contains('maintenance')) {
        if (pCategory.contains('service') ||
            pType.contains('service') ||
            pName.contains('service') ||
            pName.contains('maintenance') ||
            pDesc.contains('service')) {
          return true;
        }
      }

      if (nameLower.contains('dispenser') || idLower.contains('dispenser') || nameLower.contains('hot') || nameLower.contains('cold')) {
        if (pType.contains('hot') ||
            pType.contains('cold') ||
            pType.contains('dispenser') ||
            pName.contains('dispenser') ||
            pName.contains('hot')) {
          return true;
        }
      }

      if (nameLower.contains('open') && (pType.contains('open') || pName.contains('open'))) {
        return true;
      }
      if (nameLower.contains('box') && (pType.contains('box') || pName.contains('box'))) {
        return true;
      }
      if (nameLower.contains('cabinet') && (pType.contains('cabinet') || pName.contains('cabinet'))) {
        return true;
      }

      if (pName.contains(nameLower) || (idLower.isNotEmpty && pName.contains(idLower))) {
        return true;
      }

      return false;
    }).toList();
  }

  List<ProductEntity> _getCategoryProducts(ProductsState state) {
    if (widget.products != null && widget.products!.isNotEmpty) {
      return widget.products!;
    }
    if (state is ProductsLoaded) {
      return _filterByCategory(state.products);
    }
    return [];
  }

  List<ProductEntity> _getFilteredAndSortedProducts(List<ProductEntity> categoryProducts) {
    List<ProductEntity> result = [];
    if (_searchQuery.isEmpty) {
      result = List.from(categoryProducts);
    } else {
      final query = _searchQuery.toLowerCase().trim();
      for (final p in categoryProducts) {
        final nameMatches = p.name.toLowerCase().contains(query);
        final descMatches = p.description?.toLowerCase().contains(query) ?? false;
        final catMatches = p.category?.toLowerCase().contains(query) ?? false;
        final typeMatches = p.type?.toLowerCase().contains(query) ?? false;
        if (nameMatches || descMatches || catMatches || typeMatches) {
          result.add(p);
        }
      }
    }

    if (_sortBy == 'Price: Low to High') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      result.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Top Rated') {
      result.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textColorSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Cart Icon Button with Badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final count = cartState.totalItemCount;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      },
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: textColorPrimary,
                        size: 24,
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$count',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: isDark ? const Color(0xFF020810) : Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Gap(8),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            final categoryProducts = _getCategoryProducts(state);
            final filtered = _getFilteredAndSortedProducts(categoryProducts);

            final isLoading = (state is ProductsLoading || state is ProductsInitial) &&
                (widget.products == null || widget.products!.isEmpty);

            return Column(
              children: [
                // Search & Sort Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Search Field
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.inter(color: textColorPrimary, fontSize: 13),
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search in ${widget.categoryName}...',
                              hintStyle: GoogleFonts.inter(color: textColorSecondary, fontSize: 12.5),
                              prefixIcon: Icon(Icons.search_rounded, color: accentColor, size: 20),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                      child: Icon(Icons.clear_rounded, color: textColorSecondary, size: 18),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      // Sort Dropdown Button
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0x8000BCE1)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            dropdownColor: surfaceColor,
                            icon: Icon(Icons.tune_rounded, color: accentColor, size: 18),
                            style: GoogleFonts.inter(color: textColorPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                            items: ['Featured', 'Price: Low to High', 'Price: High to Low', 'Top Rated']
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: GoogleFonts.inter(color: textColorPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _sortBy = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                // Product Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Showing ${filtered.length} products',
                        style: GoogleFonts.inter(
                          color: textColorSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                // Main Content (Loading, Error, Grid, or Empty State)
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: accentColor),
                        )
                      : (state is ProductsError && (widget.products == null || widget.products!.isEmpty))
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: AppColors.accentRed,
                                    size: 48,
                                  ),
                                  const Gap(12),
                                  Text(
                                    state.message,
                                    style: GoogleFonts.inter(color: textColorSecondary),
                                  ),
                                  const Gap(16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                                    ),
                                    onPressed: () {
                                      context.read<ProductsBloc>().add(const LoadProducts());
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              color: accentColor,
                              backgroundColor: surfaceColor,
                              onRefresh: () async {
                                context.read<ProductsBloc>().add(const LoadProducts());
                                await Future.delayed(const Duration(milliseconds: 600));
                              },
                              child: filtered.isEmpty
                                  ? SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: surfaceColor,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: borderColor),
                                          boxShadow: isDark
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.04),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: accentColor.withValues(alpha: 0.12),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.search_off_rounded,
                                                size: 48,
                                                color: accentColor,
                                              ),
                                            ),
                                            const Gap(16),
                                            Text(
                                              _searchQuery.isNotEmpty
                                                  ? 'No products match "$_searchQuery"'
                                                  : 'No products found in ${widget.categoryName}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.outfit(
                                                color: textColorPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Gap(8),
                                            Text(
                                              'We couldn\'t find any products matching your selection. Explore our complete catalog to browse all purifiers and accessories.',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                color: textColorSecondary,
                                                fontSize: 12.5,
                                                height: 1.4,
                                              ),
                                            ),
                                            const Gap(24),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (_) => const ShopPage()),
                                                );
                                              },
                                              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                                              label: Text(
                                                'Explore All Products',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: accentColor,
                                                foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      padding: const EdgeInsets.all(16),
                                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.57,
                                        crossAxisSpacing: 14,
                                        mainAxisSpacing: 14,
                                      ),
                                      itemCount: filtered.length,
                                      itemBuilder: (context, index) {
                                        return ShopProductCard(
                                          product: filtered[index],
                                          isHorizontal: false,
                                        );
                                      },
                                    ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

