import 'package:cloud_firestore/cloud_firestore.dart';
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
    try {
      final snapshot = await FirebaseFirestore.instance.collection('services').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((docSnap) {
          final data = docSnap.data();
          return ServiceRequestEntity(
            id: docSnap.id,
            machineName: data['machineModel'] ?? data['machineType'] ?? 'RO Water Purifier',
            address: data['address'] ?? 'N/A',
            date: data['appointmentDate'] ?? data['preferredDate'] ?? '',
            timeSlot: data['appointmentTime'] ?? data['preferredSlot'] ?? '',
            description: data['problemDetails'] ?? data['problemDescription'] ?? '',
            status: data['status'] ?? 'Pending',
          );
        }).toList();
      }
    } catch (e) {
      // Fallback
    }
    return List.unmodifiable(_services);
  }

  Future<List<OrderEntity>> getOrdersHistory() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('orders').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((docSnap) {
          final data = docSnap.data();
          final items = data['items'] as List<dynamic>?;
          final title = (items != null && items.isNotEmpty)
              ? (items[0]['name'] ?? 'Purifier Order')
              : 'RO Water Purifier Order';
          return OrderEntity(
            id: docSnap.id,
            title: title,
            date: data['createdAt'] != null ? data['createdAt'].toString() : '',
            amount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
            status: data['status'] ?? 'Pending',
          );
        }).toList();
      }
    } catch (e) {
      // Fallback
    }
    return List.unmodifiable(_orders);
  }

  Future<List<InvoiceEntity>> getInvoicesHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_invoices);
  }

  Future<ShippingAddressEntity> getDefaultShippingAddress() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _defaultAddress;
  }

  Future<List<String>> getAvailableMachines() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_availableMachines);
  }

  Future<void> submitServiceRequest(ServiceRequestEntity request) async {
    try {
      await FirebaseFirestore.instance.collection('services').add({
        'machineModel': request.machineName,
        'customerName': 'App User',
        'phone': 'N/A',
        'address': request.address,
        'appointmentDate': request.date,
        'appointmentTime': request.timeSlot,
        'problemDetails': request.description,
        'status': request.status.isNotEmpty ? request.status : 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Fallback
    }
    _services.insert(0, request);
  }
}

