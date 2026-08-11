import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
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
  final AuthLocalDatasource localDatasource;

  ServicesRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    AuthLocalDatasource? localDatasource,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance,
        localDatasource = localDatasource ?? AuthLocalDatasource();

  Future<String> _getCurrentUserId() async {
    final localPhone = await localDatasource.getUserPhone();
    if (localPhone != null && localPhone.isNotEmpty) {
      return localPhone;
    }
    final localUserId = await localDatasource.getUserId();
    if (localUserId != null && localUserId.isNotEmpty) {
      return localUserId;
    }
    final authUser = auth.currentUser;
    if (authUser?.phoneNumber != null && authUser!.phoneNumber!.isNotEmpty) {
      return authUser.phoneNumber!;
    }
    if (authUser?.uid != null && authUser!.uid.isNotEmpty) {
      return authUser.uid;
    }
    return 'guest_user';
  }

  /// Generates a unique, sequential Service ID using a Firestore transaction (001, 002, 003...)
  Future<String> _generateNextServiceId() async {
    final counterRef = firestore.collection('counters').doc('service_requests');

    try {
      return await firestore.runTransaction<String>((transaction) async {
        final snapshot = await transaction.get(counterRef);
        int nextCount = 1;

        if (snapshot.exists) {
          final currentCount = snapshot.data()?['currentCount'] as int? ?? 0;
          nextCount = currentCount + 1;
        } else {
          final existingDocs = await firestore.collection('service_requests').get();
          if (existingDocs.docs.isNotEmpty) {
            nextCount = existingDocs.docs.length + 1;
          }
        }

        transaction.set(counterRef, {'currentCount': nextCount}, SetOptions(merge: true));

        return nextCount.toString().padLeft(3, '0');
      });
    } catch (_) {
      // Fallback if transaction fails
      final existingDocs = await firestore.collection('service_requests').get();
      final count = existingDocs.docs.length + 1;
      return count.toString().padLeft(3, '0');
    }
  }

  @override
  Future<List<WaterServiceModel>> getServicesHistory() async {
    final userId = await _getCurrentUserId();
    QuerySnapshot<Map<String, dynamic>> snapshot;
    
    try {
      snapshot = await firestore
          .collection('service_requests')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
    } catch (_) {
      try {
        snapshot = await firestore
            .collection('service_requests')
            .where('userId', isEqualTo: userId)
            .limit(10)
            .get();
      } catch (_) {
        try {
          snapshot = await firestore
              .collection('services')
              .where('userId', isEqualTo: userId)
              .limit(10)
              .get();
        } catch (_) {
          snapshot = await firestore
              .collection('service_requests')
              .limit(10)
              .get();
        }
      }
    }

    if (snapshot.docs.isEmpty && userId != 'guest_user') {
      try {
        final phoneSnapshot = await firestore
            .collection('service_requests')
            .where('phone', isEqualTo: userId)
            .get();
        if (phoneSnapshot.docs.isNotEmpty) {
          snapshot = phoneSnapshot;
        }
      } catch (_) {}
    }

    return snapshot.docs
        .map((docSnap) => WaterServiceModel.fromFirestore(docSnap))
        .toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersHistory() async {
    final userId = await _getCurrentUserId();
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
    } catch (_) {
      try {
        snapshot = await firestore
            .collection('orders')
            .where('customerPhone', isEqualTo: userId)
            .limit(10)
            .get();
      } catch (_) {
        snapshot = await firestore
            .collection('orders')
            .limit(10)
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
    final userId = await _getCurrentUserId();
    QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await firestore
          .collection('invoices')
          .where('userId', isEqualTo: userId)
          .limit(10)
          .get();
    } catch (_) {
      snapshot = await firestore.collection('invoices').limit(10).get();
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
    final userId = await _getCurrentUserId();
    if (userId != 'guest_user') {
      try {
        final snapshot = await firestore
            .collection('customers')
            .doc(userId)
            .collection('addresses')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          return ShippingAddressEntity(
            id: snapshot.docs.first.id,
            addressLine: data['address'] ?? '',
            city: '',
            isDefault: true,
          );
        }
      } catch (_) {}
    }
    return const ShippingAddressEntity(
      id: '',
      addressLine: '',
      city: '',
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
    final userId = await _getCurrentUserId();
    String customerName = 'App User';
    String phone = userId;

    if (userId != 'guest_user') {
      try {
        final userDoc = await firestore.collection('customers').doc(userId).get();
        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null) {
            if (data['name'] != null && (data['name'] as String).isNotEmpty) {
              customerName = data['name'];
            }
            if (data['phone'] != null && (data['phone'] as String).isNotEmpty) {
              phone = data['phone'];
            }
          }
        }
      } catch (_) {}
    }

    final serviceId = await _generateNextServiceId();

    final mapData = {
      'serviceId': serviceId,
      'requestId': serviceId,
      'customerName': customerName,
      'phone': phone,
      'address': request.address,
      'appointmentDate': request.date,
      'appointmentTime': request.timeSlot,
      'problemDetails': request.description,
      'status': request.status.isNotEmpty ? request.status : 'Pending',
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await firestore.collection('service_requests').add(mapData);
  }
}
