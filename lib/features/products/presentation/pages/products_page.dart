import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/pages/cart_page.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/add_product_modal.dart';
import '../widgets/product_item_card.dart';

import 'shop_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProductsBloc>();
    if (bloc.state is ProductsInitial) {
      bloc.add(const LoadProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColorPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textColorSecondary = isDark
        ? Colors.white.withValues(alpha: 0.65)
        : const Color(0xFF64748B);
    final accentColor = isDark ? const Color(0xFF00BCE1) : AppColors.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Products',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
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
                      icon: Icon(Icons.shopping_cart_outlined, color: textColorPrimary),
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
                              '${cartState.totalItemCount}',
                              style: GoogleFonts.inter(
                                color: isDark ? const Color(0xFF020810) : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF60A5FA), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => AddProductModal.show(context),
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading || state is ProductsInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: accentColor,
              ),
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
                    style: GoogleFonts.inter(
                      color: textColorSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductsBloc>().add(const LoadProducts());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductsLoaded) {
            final myProducts = state.myProducts;

            return RefreshIndicator(
              color: accentColor,
              backgroundColor: theme.cardColor,
              onRefresh: () async {
                context.read<ProductsBloc>().add(const LoadProducts());
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: myProducts.isEmpty
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 48,
                                    color: textColorSecondary,
                                  ),
                                ),
                                const Gap(20),
                                Text(
                                  'No Products Yet',
                                  style: GoogleFonts.outfit(
                                    color: textColorPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  'Add your device or shop from our store.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: textColorSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const Gap(24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const ShopPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      foregroundColor: isDark ? const Color(0xFF020810) : Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: isDark ? const Color(0xFF020810) : Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Shop Now',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      AddProductModal.show(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: accentColor),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: Icon(Icons.add_rounded, color: accentColor, size: 18),
                                    label: Text(
                                      'Add Device',
                                      style: GoogleFonts.inter(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 90),
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      cacheExtent: 800,
                      itemCount: myProducts.length,
                      itemBuilder: (context, index) {
                        return RepaintBoundary(
                          child: ProductItemCard(
                            product: myProducts[index],
                          ),
                        );
                      },
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
