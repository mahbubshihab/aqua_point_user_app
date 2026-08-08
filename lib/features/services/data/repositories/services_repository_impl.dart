import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/water_service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import '../datasources/services_remote_datasource.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource remoteDatasource;

  ServicesRepositoryImpl({
    ServicesRemoteDatasource? remoteDatasource,
  }) : remoteDatasource = remoteDatasource ?? ServicesRemoteDatasourceImpl();

  @override
  Future<List<ServiceRequestEntity>> getServicesHistory() async {
    try {
      final remoteList = await remoteDatasource.getServicesHistory();
      if (remoteList.isNotEmpty) {
        return remoteList.map((m) => ServiceRequestEntity(
          id: m.id,
          machineName: m.machineName,
          address: m.address,
          date: m.date,
          timeSlot: m.timeSlot,
          description: m.description,
          status: m.status,
        )).toList();
      }
    } catch (_) {}
    return Future.value([]);
  }

  @override
  Future<List<OrderEntity>> getOrdersHistory() async {
    try {
      final remoteOrders = await remoteDatasource.getOrdersHistory();
      if (remoteOrders.isNotEmpty) return remoteOrders;
    } catch (_) {}
    return Future.value([]);
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesHistory() async {
    try {
      final remoteInvoices = await remoteDatasource.getInvoicesHistory();
      if (remoteInvoices.isNotEmpty) return remoteInvoices;
    } catch (_) {}
    return Future.value([]);
  }

  @override
  Future<ShippingAddressEntity> getDefaultShippingAddress() async {
    try {
      return await remoteDatasource.getDefaultShippingAddress();
    } catch (_) {
      return Future.value(const ShippingAddressEntity(
        id: '',
        addressLine: '',
        city: '',
        isDefault: true,
      ));
    }
  }

  @override
  Future<List<String>> getAvailableMachines() async {
    try {
      final machines = await remoteDatasource.getAvailableMachines();
      if (machines.isNotEmpty) return machines;
    } catch (_) {}
    return Future.value([]);
  }

  @override
  Future<void> submitServiceRequest(ServiceRequestEntity request) async {
    final waterEntity = WaterServiceEntity(
      id: request.id,
      machineName: request.machineName,
      address: request.address,
      date: request.date,
      timeSlot: request.timeSlot,
      description: request.description,
      status: request.status,
    );
    await remoteDatasource.submitServiceRequest(waterEntity);
  }
}

