import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/water_service_entity.dart';
import '../models/water_service_model.dart';

abstract class ServicesRemoteDatasource {
  Future<List<WaterServiceModel>> getServicesHistory();
  Future<List<OrderEntity>> getOrdersHistory();
  Future<List<InvoiceEntity>> getInvoicesHistory();
  Future<ShippingAddressEntity> getDefaultShippingAddress();
  Future<List<String>> getAvailableMachines();
  Future<void> submitServiceRequest(WaterServiceEntity request);
}

class ServicesRemoteDatasourceImpl implements ServicesRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ServicesRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  String get _currentUserId => auth.currentUser?.uid ?? 'guest_user';

  @override
  Future<List<WaterServiceModel>> getServicesHistory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('services')
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .limit(15)
          .get();
    } catch (_) {
      try {
        snapshot = await firestore
            .collection('services')
            .where('userId', isEqualTo: _currentUserId)
            .limit(15)
            .get();
      } catch (_) {
        snapshot = await firestore
            .collection('services')
            .limit(15)
            .get();
      }
    }

    return snapshot.docs
        .map((docSnap) => WaterServiceModel.fromFirestore(docSnap))
        .toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersHistory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .limit(15)
          .get();
    } catch (_) {
      try {
        snapshot = await firestore
            .collection('orders')
            .where('userId', isEqualTo: _currentUserId)
            .limit(15)
            .get();
      } catch (_) {
        snapshot = await firestore
            .collection('orders')
            .limit(15)
            .get();
      }
    }

    return snapshot.docs.map((docSnap) {
      final data = docSnap.data();
      final items = data['items'] as List<dynamic>?;
      final title = (items != null && items.isNotEmpty)
          ? (items[0]['name'] ?? 'Purifier Order')
          : (data['title'] ?? 'RO Water Purifier Order');
      return OrderEntity(
        id: docSnap.id,
        title: title,
        date: data['createdAt'] != null
            ? data['createdAt'].toString()
            : (data['date'] ?? ''),
        amount: (data['totalAmount'] as num?)?.toDouble() ??
            (data['amount'] as num?)?.toDouble() ??
            0.0,
        status: data['status'] ?? 'Pending',
      );
    }).toList();
  }

  @override
  Future<List<InvoiceEntity>> getInvoicesHistory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('invoices')
          .where('userId', isEqualTo: _currentUserId)
          .limit(15)
          .get();
    } catch (_) {
      snapshot = await firestore.collection('invoices').limit(15).get();
    }

    return snapshot.docs.map((docSnap) {
      final data = docSnap.data();
      return InvoiceEntity(
        id: docSnap.id,
        invoiceNumber: data['invoiceNumber'] ?? 'INV-${docSnap.id.substring(0, 5)}',
        date: data['date'] ?? '',
        amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
        status: data['status'] ?? 'Unpaid',
      );
    }).toList();
  }

  @override
  Future<ShippingAddressEntity> getDefaultShippingAddress() async {
    final snapshot = await firestore.collection('addresses').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      return ShippingAddressEntity(
        id: snapshot.docs.first.id,
        addressLine: data['addressLine'] ?? data['address'] ?? 'House 12, Road 4, Block C',
        city: data['city'] ?? 'Banani, Dhaka',
        isDefault: data['isDefault'] ?? true,
      );
    }
    return const ShippingAddressEntity(
      id: 'ADDR-1',
      addressLine: 'House 12, Road 4, Block C',
      city: 'Banani, Dhaka',
      isDefault: true,
    );
  }

  @override
  Future<List<String>> getAvailableMachines() async {
    final snapshot = await firestore.collection('products').limit(15).get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs
          .map((doc) => doc.data()['name']?.toString() ?? 'Aqua Pure RO System')
          .toList();
    }
    return [
      'Aqua Pure RO System (Model X1)',
      'Aqua Clean UV Filter (Model V2)',
      'Aqua Smart Alkaline Purifier (Model S3)',
    ];
  }

  @override
  Future<void> submitServiceRequest(WaterServiceEntity request) async {
    final model = WaterServiceModel.fromEntity(request);
    final mapData = model.toFirestore();
    mapData['userId'] = _currentUserId;
    await firestore.collection('services').add(mapData);
  }
}
