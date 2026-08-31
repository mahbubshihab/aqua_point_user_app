import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/bloc/products_bloc.dart';
import '../../../products/presentation/bloc/products_state.dart';
import '../../../products/presentation/pages/product_detail_page.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/service_request_entity.dart';
import '../bloc/services_bloc.dart';
import '../bloc/services_event.dart';
import '../bloc/services_state.dart';
import 'create_service_request_page.dart';

class ServicesHistoryPage extends StatefulWidget {
  final int initialTabIndex;

  const ServicesHistoryPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<ServicesHistoryPage> createState() => _ServicesHistoryPageState();
}

class _ServicesHistoryPageState extends State<ServicesHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex > 1 ? 1 : widget.initialTabIndex,
    );
    _tabController.addListener(_handleTabSelection);

    // Initial load
    final bloc = context.read<ServicesBloc>();
    if (bloc.state is ServicesInitial) {
      bloc.add(const LoadServicesHistory());
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      context.read<ServicesBloc>().add(SelectHistoryTab(_tabController.index));
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToCreateRequest() {
    final bloc = context.read<ServicesBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const CreateServiceRequestPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const tabBgColor = Color(0xFFF1F5F9);
    const tabIndicatorColor = Colors.white;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Services',
          style: GoogleFonts.outfit(
            color: textColorPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: tabBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: tabIndicatorColor,
                boxShadow: AppShadows.soft,
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: textColorSecondary,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Services'),
                Tab(text: 'Orders'),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServicesLoaded) {
            if (_tabController.index != state.selectedTab) {
              _tabController.animateTo(state.selectedTab);
            }
          }
        },
        builder: (context, state) {
          if (state is ServicesLoading || state is ServicesInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is ServicesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
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
                      context.read<ServicesBloc>().add(const LoadServicesHistory());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Retry', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          if (state is ServicesLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _ServicesTabContent(servicesList: state.servicesList),
                _OrdersTabContent(ordersList: state.ordersList),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),

      // Better Modern Floating Action Button (FAB)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90, right: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _navigateToCreateRequest,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0052CC), Color(0xFF0088FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0052CC).withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.build_circle_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Request Service',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _EmptyStateView({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(20),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: textColorPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: textColorSecondary,
                    fontSize: 14,
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

class _ServicesTabContent extends StatelessWidget {
  final List<ServiceRequestEntity> servicesList;

  const _ServicesTabContent({required this.servicesList});

  String _formatRequestId(String id, int index) {
    final clean = id.replaceAll('#', '').trim();
    final numVal = int.tryParse(clean);
    if (numVal != null) {
      return '#${numVal.toString().padLeft(3, '0')}';
    }
    if (clean.length < 20 && clean.isNotEmpty) {
      return '#${clean.padLeft(3, '0')}';
    }
    return '#${(index + 1).toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Colors.white;
    const cardBorderColor = Color(0xFFE2E8F0);
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);
    const descBgColor = Color(0xFFF8FAFC);

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<ServicesBloc>().add(const LoadServicesHistory());
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: servicesList.isEmpty
          ? const _EmptyStateView(
              title: 'No history found',
              subtitle: 'You have not submitted any service requests yet.',
              icon: Icons.build_circle_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              cacheExtent: 800,
              itemCount: servicesList.length,
              itemBuilder: (context, index) {
                final item = servicesList[index];
                return RepaintBoundary(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                        border: Border.all(color: cardBorderColor),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatRequestId(item.id, index),
                                style: GoogleFonts.inter(
                                  color: AppColors.secondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              _buildStatusBadge(item.status),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            'Service Request',
                            style: GoogleFonts.outfit(
                              color: textColorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 16,
                                color: textColorSecondary,
                              ),
                              const Gap(8),
                              Text(
                                item.date,
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const Gap(16),
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: textColorSecondary,
                              ),
                              const Gap(8),
                              Text(
                                item.timeSlot,
                                style: GoogleFonts.inter(
                                  color: textColorSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: textColorSecondary,
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  item.address,
                                  style: GoogleFonts.inter(
                                    color: textColorSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          if (item.technician != null &&
                              item.technician != 'Unassigned' &&
                              item.technician!.trim().isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF10B981), Color(0xFF00BCE1)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00BCE1).withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Technician: ${item.technician}',
                                          style: GoogleFonts.outfit(
                                            color: textColorPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (item.technicianPhone != null &&
                                            item.technicianPhone!.trim().isNotEmpty) ...[
                                          const Gap(2),
                                          Text(
                                            item.technicianPhone!,
                                            style: GoogleFonts.inter(
                                              color: textColorSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (item.technicianPhone != null &&
                                      item.technicianPhone!.trim().isNotEmpty) ...[
                                    const Gap(8),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          final phoneClean = item.technicianPhone!.replaceAll(RegExp(r'\s+'), '');
                                          final uri = Uri.parse('tel:$phoneClean');
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF10B981), Color(0xFF00BCE1)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.phone_in_talk_rounded,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                              const Gap(6),
                                              Text(
                                                'Call',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: cardBorderColor),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.engineering_outlined,
                                    size: 14,
                                    color: textColorSecondary,
                                  ),
                                  Gap(6),
                                  Text(
                                    'Technician: Assigning soon',
                                    style: TextStyle(
                                      color: textColorSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (item.description.isNotEmpty) ...[
                            const Gap(12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: descBgColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: cardBorderColor),
                              ),
                              child: Text(
                                item.description,
                                style: GoogleFonts.inter(
                                  color: textColorPrimary,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = AppColors.success;
        break;
      case 'in progress':
        color = AppColors.secondary;
        break;
      case 'pending':
      default:
        color = AppColors.warning;
        break;
    }
    return StatBadge(
      text: status,
      backgroundColor: color.withValues(alpha: 0.15),
      textColor: color,
    );
  }
}

class _OrdersTabContent extends StatelessWidget {
  final List<OrderEntity> ordersList;

  const _OrdersTabContent({required this.ordersList});

  void _navigateToProductDetail(BuildContext context, OrderEntity item) {
    ProductEntity? matchingProduct;

    try {
      final productsState = context.read<ProductsBloc>().state;
      if (productsState is ProductsLoaded) {
        final allProducts = [
          ...productsState.products,
          ...productsState.myProducts,
        ];

        for (final product in allProducts) {
          final isIdMatch = (item.productId != null && product.id == item.productId) ||
              (product.id == item.id);
          final isNameMatch = product.name.trim().toLowerCase() == item.title.trim().toLowerCase();

          if (isIdMatch || isNameMatch) {
            matchingProduct = product;
            break;
          }
        }
      }
    } catch (_) {
      // If ProductsBloc is not found in context, fallback will be used
    }

    final targetProduct = matchingProduct ??
        ProductEntity(
          id: item.productId ?? item.id,
          name: item.title,
          photoUrl: item.imageUrl,
          price: item.amount,
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: targetProduct),
      ),
    );
  }

  Widget _buildProductThumbnail(String? imageUrl) {
    Widget placeholder = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.water_drop_rounded,
          color: AppColors.primary,
          size: 28,
        ),
      ),
    );

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => placeholder,
          ),
        ),
      );
    }

    return placeholder;
  }

  Widget _buildOrderStatusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'DELIVERED':
      case 'COMPLETED':
        color = AppColors.success;
        break;
      case 'SHIPPED':
      case 'PROCESSING':
      case 'IN PROGRESS':
        color = AppColors.secondary;
        break;
      case 'CANCELLED':
        color = AppColors.error;
        break;
      case 'PENDING':
      default:
        color = AppColors.warning;
        break;
    }
    return StatBadge(
      text: status,
      backgroundColor: color.withValues(alpha: 0.15),
      textColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Colors.white;
    const cardBorderColor = Color(0xFFE2E8F0);
    const textColorPrimary = Color(0xFF0F172A);
    const textColorSecondary = Color(0xFF64748B);

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<ServicesBloc>().add(const LoadServicesHistory());
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: ordersList.isEmpty
          ? const _EmptyStateView(
              title: 'No history found',
              subtitle: 'You have no product or component order records.',
              icon: Icons.shopping_bag_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              cacheExtent: 800,
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                final item = ordersList[index];
                return RepaintBoundary(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                        border: Border.all(color: cardBorderColor),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _navigateToProductDetail(context, item),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.id,
                                      style: GoogleFonts.inter(
                                        color: AppColors.secondary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    _buildOrderStatusBadge(item.status),
                                  ],
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    _buildProductThumbnail(item.imageUrl),
                                    const Gap(14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.outfit(
                                              color: textColorPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Gap(4),
                                          if (item.date.isNotEmpty) ...[
                                            Text(
                                              item.date,
                                              style: GoogleFonts.inter(
                                                color: textColorSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Gap(4),
                                          ],
                                          Text(
                                            '৳${item.amount.toStringAsFixed(0)}',
                                            style: GoogleFonts.inter(
                                              color: AppColors.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(8),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: textColorSecondary,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
