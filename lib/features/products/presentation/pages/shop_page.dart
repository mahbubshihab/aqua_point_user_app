import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/cart_page.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/shop_product_card.dart';
import 'category_shop_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: textColorPrimary,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Aqua Point Shop',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Cart Icon Button with Counter Badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final count = cartState.totalItemCount;
              return Stack(
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
                ],
              );
            },
          ),
          const Gap(8),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading || state is ProductsInitial) {
              return Center(
                child: CircularProgressIndicator(color: accentColor),
              );
            }

            if (state is ProductsError) {
              return Center(
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
              );
            }

            if (state is ProductsLoaded) {
              final allProducts = state.products;
              final categories = state.categories;

              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.inter(
                          color: textColorPrimary,
                          fontSize: 13.5,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search RO purifiers, filters & spare parts...',
                          hintStyle: GoogleFonts.inter(
                            color: textColorSecondary,
                            fontSize: 12.5,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: accentColor,
                            size: 22,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: textColorSecondary,
                                    size: 18,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  // Category Filter Pills Bar
                  _buildCategoryFilterPills(categories, isDark),
                  const Gap(12),
                  // Main Body with Category-wise Product Sections
                  Expanded(
                    child: RefreshIndicator(
                      color: accentColor,
                      backgroundColor: cardBgColor,
                      onRefresh: () async {
                        context.read<ProductsBloc>().add(const LoadProducts());
                        await Future.delayed(const Duration(milliseconds: 600));
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildCategorySections(
                            context,
                            allProducts,
                            categories,
                            isDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilterPills(List<CategoryEntity> categories, bool isDark) {
    final catNames = ['All', ...categories.map((c) => c.name)];
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: catNames.length,
        itemBuilder: (context, index) {
          final cat = catNames[index];
          final isSelected = _selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                }
              },
              selectedColor: accentColor,
              backgroundColor: cardBgColor,
              labelStyle: GoogleFonts.inter(
                color: isSelected
                    ? (isDark ? const Color(0xFF020810) : Colors.white)
                    : textColorSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? accentColor : borderColor,
                ),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCategorySections(
    BuildContext context,
    List<ProductEntity> allProducts,
    List<CategoryEntity> categories,
    bool isDark,
  ) {
    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    List<Widget> sectionWidgets = [];

    // Filter products by search query first if provided
    List<ProductEntity> filteredBySearch = allProducts;
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredBySearch = allProducts.where((p) {
        final nameMatch = p.name.toLowerCase().contains(query);
        final descMatch = p.description?.toLowerCase().contains(query) ?? false;
        final catMatch = p.category?.toLowerCase().contains(query) ?? false;
        return nameMatch || descMatch || catMatch;
      }).toList();
    }

    // Group products by Category
    Map<String, List<ProductEntity>> categoryMap = {};

    // Initialize with known categories to preserve section order
    for (final cat in categories) {
      categoryMap[cat.name] = [];
    }

    for (final product in filteredBySearch) {
      final cat = product.category ?? 'RO Water Purifiers';
      if (!categoryMap.containsKey(cat)) {
        categoryMap[cat] = [];
      }
      categoryMap[cat]!.add(product);
    }

    // Filter by selected category pill if not 'All'
    if (_selectedCategory != 'All') {
      categoryMap.removeWhere((catName, _) => catName != _selectedCategory);
    }

    if (categoryMap.isEmpty || categoryMap.values.every((list) => list.isEmpty)) {
      return [
        const Gap(60),
        Center(
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 56, color: textColorSecondary),
              const Gap(12),
              Text(
                _searchQuery.isNotEmpty ? 'No products match "$_searchQuery"' : 'No products found',
                style: GoogleFonts.inter(color: textColorSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ];
    }

    categoryMap.forEach((categoryName, products) {
      if (products.isEmpty) return;

      sectionWidgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category Name Header
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
                    categoryName,
                    style: GoogleFonts.outfit(
                      color: textColorPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              // "See All >" Link Button
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryShopPage(
                        categoryName: categoryName,
                        products: categoryMap[categoryName] ?? [],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: GoogleFonts.inter(
                          color: accentColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(2),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: accentColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Horizontal Product List
      sectionWidgets.add(
        SizedBox(
          height: 290,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ShopProductCard(
                product: products[index],
                isHorizontal: true,
              );
            },
          ),
        ),
      );

      sectionWidgets.add(const Gap(12));
    });

    sectionWidgets.add(const Gap(24));
    return sectionWidgets;
  }
}
