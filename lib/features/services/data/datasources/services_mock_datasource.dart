import '../../domain/entities/service_request_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/invoice_entity.dart';

class ServicesMockDatasource {
  final List<ServiceRequestEntity> _services = [];
  final List<OrderEntity> _orders = [];
  final List<InvoiceEntity> _invoices = [];
  final ShippingAddressEntity _defaultAddress = const ShippingAddressEntity(
    id: '',
    addressLine: '',
    city: '',
    isDefault: false,
  );
  final List<String> _availableMachines = [];

  Future<List<ServiceRequestEntity>> getServicesHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_services);
  }

  Future<List<OrderEntity>> getOrdersHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_orders);
  }

  Future<List<InvoiceEntity>> getInvoicesHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_invoices);
  }

  Future<ShippingAddressEntity> getDefaultShippingAddress() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _defaultAddress;
  }

  Future<List<String>> getAvailableMachines() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_availableMachines);
  }

  Future<void> submitServiceRequest(ServiceRequestEntity request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _services.insert(0, request);
  }
}
