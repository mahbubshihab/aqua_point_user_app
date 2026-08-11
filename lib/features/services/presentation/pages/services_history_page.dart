import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/widgets/stat_badge.dart';
import '../../domain/entities/invoice_entity.dart';
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
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ServicesBloc>(),
          child: const CreateServiceRequestPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Services',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surface,
                boxShadow: AppShadows.soft,
              ),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Services'),
                Tab(text: 'Orders'),
                Tab(text: 'Invoices'),
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
                      color: AppColors.textSecondary,
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Retry', style: GoogleFonts.inter()),
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
                _InvoicesTabContent(invoicesList: state.invoicesList),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          onPressed: _navigateToCreateRequest,
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: const Icon(
            Icons.build_rounded,
            color: Colors.white,
            size: 20,
          ),
          label: Text(
            'Request Service',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5,
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
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
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
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                        border: Border.all(color: AppColors.border),
                      ),
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
                              _buildStatusBadge(item.status),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            'Service Request',
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
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
                                color: AppColors.textSecondary,
                              ),
                              const Gap(8),
                              Text(
                                item.date,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const Gap(16),
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const Gap(8),
                              Text(
                                item.timeSlot,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
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
                                color: AppColors.textSecondary,
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  item.address,
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (item.description.isNotEmpty) ...[
                            const Gap(12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Text(
                                item.description,
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
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
      backgroundColor: color.withValues(alpha: 0.1),
      textColor: color,
    );
  }
}

class _OrdersTabContent extends StatelessWidget {
  final List<OrderEntity> ordersList;

  const _OrdersTabContent({required this.ordersList});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
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
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                        border: Border.all(color: AppColors.border),
                      ),
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
                              StatBadge(
                                text: item.status,
                                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                                textColor: AppColors.success,
                              ),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            item.title,
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            '${item.date} • ৳${item.amount.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _InvoicesTabContent extends StatelessWidget {
  final List<InvoiceEntity> invoicesList;

  const _InvoicesTabContent({required this.invoicesList});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        context.read<ServicesBloc>().add(const LoadServicesHistory());
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: invoicesList.isEmpty
          ? const _EmptyStateView(
              title: 'No history found',
              subtitle: 'You have no billing or invoice records.',
              icon: Icons.receipt_long_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              cacheExtent: 800,
              itemCount: invoicesList.length,
              itemBuilder: (context, index) {
                final item = invoicesList[index];
                return RepaintBoundary(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppShadows.soft,
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.id,
                                  style: GoogleFonts.outfit(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  item.date,
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${item.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(6),
                              StatBadge(
                                text: item.status,
                                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                                textColor: AppColors.success,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
