import 'package:equatable/equatable.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/service_request_entity.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesState {
  final int selectedTab;
  final List<ServiceRequestEntity> servicesList;
  final List<OrderEntity> ordersList;
  final List<InvoiceEntity> invoicesList;

  const ServicesLoaded({
    required this.selectedTab,
    required this.servicesList,
    required this.ordersList,
    required this.invoicesList,
  });

  ServicesLoaded copyWith({
    int? selectedTab,
    List<ServiceRequestEntity>? servicesList,
    List<OrderEntity>? ordersList,
    List<InvoiceEntity>? invoicesList,
  }) {
    return ServicesLoaded(
      selectedTab: selectedTab ?? this.selectedTab,
      servicesList: servicesList ?? this.servicesList,
      ordersList: ordersList ?? this.ordersList,
      invoicesList: invoicesList ?? this.invoicesList,
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        servicesList,
        ordersList,
        invoicesList,
      ];
}

class ServiceRequestSubmitting extends ServicesState {
  const ServiceRequestSubmitting();
}

class ServiceRequestSuccess extends ServicesState {
  const ServiceRequestSuccess();
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}
