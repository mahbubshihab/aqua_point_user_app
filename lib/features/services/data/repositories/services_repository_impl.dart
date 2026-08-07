import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_mock_datasource.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesMockDatasource datasource;

  ServicesRepositoryImpl({required this.datasource});

  @override
  Future<List<ServiceRequestEntity>> getServicesHistory() {
    return datasource.getServicesHistory();
  }

  @override
  Future<List<OrderEntity>> getOrdersHistory() {
    return datasource.getOrdersHistory();
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesHistory() {
    return datasource.getInvoicesHistory();
  }

  @override
  Future<ShippingAddressEntity> getDefaultShippingAddress() {
    return datasource.getDefaultShippingAddress();
  }

  @override
  Future<List<String>> getAvailableMachines() {
    return datasource.getAvailableMachines();
  }

  @override
  Future<void> submitServiceRequest(ServiceRequestEntity request) {
    return datasource.submitServiceRequest(request);
  }
}
