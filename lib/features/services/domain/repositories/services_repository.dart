import '../entities/service_request_entity.dart';
import '../entities/shipping_address_entity.dart';
import '../entities/order_entity.dart';
import '../entities/invoice_entity.dart';

abstract class ServicesRepository {
  Future<List<ServiceRequestEntity>> getServicesHistory();
  Future<List<OrderEntity>> getOrdersHistory();
  Future<List<InvoiceEntity>> getInvoicesHistory();
  Future<ShippingAddressEntity> getDefaultShippingAddress();
  Future<List<String>> getAvailableMachines();
  Future<void> submitServiceRequest(ServiceRequestEntity request);
}
