import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/product_type_section.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/cart_page.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import 'category_shop_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTypeOrCategory = 'All';
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
                          hintText: 'Search Open, Box, Cabinet purifiers...',
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
                  // Filter Pills Bar (Type-wise & All)
                  _buildTypeFilterPills(isDark),
                  const Gap(12),
                  // Main Body with Type-wise Product Sections
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildTypeSections(
                              context,
                              allProducts,
                              isDark,
                            ),
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

  Widget _buildTypeFilterPills(bool isDark) {
    final filterNames = [
      'All',
      'Open Type',
      'Box Type',
      'Hot Cold Normal',
      'Cabinet Type',
    ];

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
        itemCount: filterNames.length,
        itemBuilder: (context, index) {
          final name = filterNames[index];
          final isSelected = _selectedTypeOrCategory == name;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedTypeOrCategory = name;
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

  List<Widget> _buildTypeSections(
    BuildContext context,
    List<ProductEntity> allProducts,
    bool isDark,
  ) {
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);

    // Filter products by search query first if provided
    List<ProductEntity> filteredList = allProducts;
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredList = allProducts.where((p) {
        final nameMatch = p.name.toLowerCase().contains(query);
        final descMatch = p.description?.toLowerCase().contains(query) ?? false;
        final catMatch = p.category?.toLowerCase().contains(query) ?? false;
        final typeMatch = p.type?.toLowerCase().contains(query) ?? false;
        return nameMatch || descMatch || catMatch || typeMatch;
      }).toList();
    }

    // Helper functions to filter products by type
    List<ProductEntity> filterByType(String tag) {
      return filteredList.where((p) {
        final t = (p.type ?? '').toLowerCase();
        final n = p.name.toLowerCase();
        if (tag == 'open') {
          return t.contains('open') || n.contains('open');
        } else if (tag == 'box') {
          return t.contains('box') || n.contains('box');
        } else if (tag == 'hot_cold_normal') {
          return t.contains('hot') || t.contains('cold') || n.contains('hot') || n.contains('dispenser');
        } else if (tag == 'cabinet') {
          return t.contains('cabinet') || n.contains('cabinet');
        }
        return false;
      }).toList();
    }

    final openProducts = filterByType('open');
    final boxProducts = filterByType('box');
    final hotColdProducts = filterByType('hot_cold_normal');
    final cabinetProducts = filterByType('cabinet');

    List<Widget> sections = [];

    // Helper to add a ProductTypeSection if it matches selected filter
    void addSectionIfMatches({
      required String filterTitle,
      required String sectionTitle,
      required String typeTag,
      required String subtitle,
      required IconData icon,
      required Color accentColor,
      required List<ProductEntity> products,
    }) {
      if (_selectedTypeOrCategory == 'All' || _selectedTypeOrCategory == filterTitle) {
        sections.add(
          ProductTypeSection(
            title: sectionTitle,
            typeTag: typeTag,
            subtitle: subtitle,
            icon: icon,
            accentColor: accentColor,
            products: products,
          ),
        );
        sections.add(const Gap(24));
      }
    }

    // 1. Open Type Purifiers
    addSectionIfMatches(
      filterTitle: 'Open Type',
      sectionTitle: 'Open Type Purifiers',
      typeTag: 'open',
      subtitle: 'Traditional open-top water purifiers',
      icon: Icons.water_drop_rounded,
      accentColor: AppColors.primary,
      products: openProducts,
    );

    // 2. Box Type Purifiers
    addSectionIfMatches(
      filterTitle: 'Box Type',
      sectionTitle: 'Box Type Purifiers',
      typeTag: 'box',
      subtitle: 'Compact box-style water purifiers',
      icon: Icons.inventory_2_rounded,
      accentColor: AppColors.secondary,
      products: boxProducts,
    );

    // 3. Hot Cold Normal
    addSectionIfMatches(
      filterTitle: 'Hot Cold Normal',
      sectionTitle: 'Hot Cold Normal',
      typeTag: 'hot_cold_normal',
      subtitle: 'Multi-temperature water dispensers',
      icon: Icons.thermostat_rounded,
      accentColor: AppColors.actionOrange,
      products: hotColdProducts,
    );

    // 4. Cabinet Type
    addSectionIfMatches(
      filterTitle: 'Cabinet Type',
      sectionTitle: 'Cabinet Type Purifiers',
      typeTag: 'cabinet',
      subtitle: 'Premium cabinet-style purifiers',
      icon: Icons.kitchen_rounded,
      accentColor: AppColors.actionPurple,
      products: cabinetProducts,
    );

    if (sections.isEmpty) {
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

    sections.add(const Gap(80));
    return sections;
  }
}
