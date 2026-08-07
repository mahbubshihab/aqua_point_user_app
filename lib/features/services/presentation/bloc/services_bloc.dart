import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/services_repository.dart';
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository repository;

  ServicesBloc({required this.repository}) : super(const ServicesInitial()) {
    on<LoadServicesHistory>(_onLoadServicesHistory);
    on<SelectHistoryTab>(_onSelectHistoryTab);
    on<SubmitServiceRequest>(_onSubmitServiceRequest);
  }

  Future<void> _onLoadServicesHistory(
    LoadServicesHistory event,
    Emitter<ServicesState> emit,
  ) async {
    final currentTab = (state is ServicesLoaded) ? (state as ServicesLoaded).selectedTab : 0;
    emit(const ServicesLoading());
    try {
      final servicesList = await repository.getServicesHistory();
      final ordersList = await repository.getOrdersHistory();
      final invoicesList = await repository.getInvoicesHistory();

      emit(ServicesLoaded(
        selectedTab: currentTab,
        servicesList: servicesList,
        ordersList: ordersList,
        invoicesList: invoicesList,
      ));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  void _onSelectHistoryTab(
    SelectHistoryTab event,
    Emitter<ServicesState> emit,
  ) {
    if (state is ServicesLoaded) {
      final currentState = state as ServicesLoaded;
      emit(currentState.copyWith(selectedTab: event.tabIndex));
    }
  }

  Future<void> _onSubmitServiceRequest(
    SubmitServiceRequest event,
    Emitter<ServicesState> emit,
  ) async {
    List<OrderEntity> currentOrders = [];
    List<InvoiceEntity> currentInvoices = [];
    int currentTab = 0;

    if (state is ServicesLoaded) {
      final loaded = state as ServicesLoaded;
      currentOrders = loaded.ordersList;
      currentInvoices = loaded.invoicesList;
      currentTab = loaded.selectedTab;
    }

    emit(const ServiceRequestSubmitting());
    try {
      await repository.submitServiceRequest(event.request);
      emit(const ServiceRequestSuccess());

      // Fetch fresh services list and return to ServicesLoaded
      final freshServices = await repository.getServicesHistory();
      final freshOrders = currentOrders.isNotEmpty
          ? currentOrders
          : await repository.getOrdersHistory();
      final freshInvoices = currentInvoices.isNotEmpty
          ? currentInvoices
          : await repository.getInvoicesHistory();

      emit(ServicesLoaded(
        selectedTab: currentTab,
        servicesList: freshServices,
        ordersList: freshOrders,
        invoicesList: freshInvoices,
      ));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
