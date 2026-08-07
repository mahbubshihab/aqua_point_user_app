import '../../domain/entities/service_request_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/invoice_entity.dart';

class ServicesMockDatasource {
  final List<ServiceRequestEntity> _services = [
    const ServiceRequestEntity(
      id: 'REQ-8842',
      machineName: 'AquaPurify Pro 5000 (Kitchen)',
      address: 'House 12, Road 4, Block C, Banani, Dhaka',
      date: '02 Aug, 2026',
      timeSlot: '10:00 AM - 12:00 PM',
      description: 'Filter cartridge replacement and full sanitization.',
      status: 'Completed',
    ),
    const ServiceRequestEntity(
      id: 'REQ-7910',
      machineName: 'HydroClean Max (Dining)',
      address: 'House 12, Road 4, Block C, Banani, Dhaka',
      date: '28 Jul, 2026',
      timeSlot: '02:00 PM - 04:00 PM',
      description: 'TDS level calibration and membrane check.',
      status: 'In Progress',
    ),
  ];

  final List<OrderEntity> _orders = [
    const OrderEntity(
      id: 'ORD-9821',
      title: 'AquaPurify Replacement Filter Set',
      date: '01 Aug, 2026',
      amount: 45.00,
      status: 'Delivered',
    ),
    const OrderEntity(
      id: 'ORD-9750',
      title: 'UV Lamp Module & Connector',
      date: '15 Jul, 2026',
      amount: 29.99,
      status: 'Delivered',
    ),
  ];

  final List<InvoiceEntity> _invoices = [
    const InvoiceEntity(
      id: 'INV-1001',
      invoiceNumber: 'INV-2026-081',
      date: '01 Aug, 2026',
      amount: 45.00,
      status: 'Paid',
    ),
    const InvoiceEntity(
      id: 'INV-1002',
      invoiceNumber: 'INV-2026-072',
      date: '15 Jul, 2026',
      amount: 29.99,
      status: 'Paid',
    ),
  ];

  final ShippingAddressEntity _defaultAddress = const ShippingAddressEntity(
    id: 'addr_1',
    addressLine: 'House 12, Road 4, Block C, Banani',
    city: 'Dhaka',
    isDefault: true,
  );

  final List<String> _availableMachines = [
    'AquaPurify Pro 5000 (Kitchen)',
    'HydroClean Max (Dining)',
    'AquaSlim RO Touch (Master Bedroom)',
  ];

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
