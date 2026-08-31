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
    final userPhone = await localDatasource.getUserPhone();
    final localUserId = await localDatasource.getUserId();
    final authUid = auth.currentUser?.uid;
    final currentUserId = await _getCurrentUserId();

    final List<Future<QuerySnapshot<Map<String, dynamic>>>> queries = [];

    if (userPhone != null && userPhone.isNotEmpty) {
      queries.add(firestore.collection('service_requests').where('phone', isEqualTo: userPhone).get());
      queries.add(firestore.collection('service_requests').where('userId', isEqualTo: userPhone).get());
    }
    if (localUserId != null && localUserId.isNotEmpty && localUserId != userPhone) {
      queries.add(firestore.collection('service_requests').where('userId', isEqualTo: localUserId).get());
    }
    if (authUid != null && authUid.isNotEmpty && authUid != userPhone && authUid != localUserId) {
      queries.add(firestore.collection('service_requests').where('userId', isEqualTo: authUid).get());
    }
    if (currentUserId.isNotEmpty && currentUserId != 'guest_user' && currentUserId != userPhone && currentUserId != localUserId && currentUserId != authUid) {
      queries.add(firestore.collection('service_requests').where('userId', isEqualTo: currentUserId).get());
    }

    final Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> uniqueDocs = {};

    if (queries.isNotEmpty) {
      final results = await Future.wait(
        queries.map((q) => q.catchError((_) => firestore.collection('service_requests').limit(0).get())),
      );

      for (final snapshot in results) {
        for (final doc in snapshot.docs) {
          uniqueDocs[doc.id] = doc;
        }
      }
    }

    if (uniqueDocs.isEmpty && currentUserId == 'guest_user') {
      try {
        final snap = await firestore.collection('service_requests').orderBy('createdAt', descending: true).limit(10).get();
        for (final doc in snap.docs) {
          uniqueDocs[doc.id] = doc;
        }
      } catch (_) {
        try {
          final snap = await firestore.collection('service_requests').limit(10).get();
          for (final doc in snap.docs) {
            uniqueDocs[doc.id] = doc;
          }
        } catch (_) {}
      }
    }

    final docList = uniqueDocs.values.toList();

    docList.sort((a, b) {
      final aData = a.data();
      final bData = b.data();
      final aTime = _getTimestamp(aData['createdAt'], aData['appointmentDate']);
      final bTime = _getTimestamp(bData['createdAt'], bData['appointmentDate']);
      return bTime.compareTo(aTime);
    });

    return docList
        .map((docSnap) => WaterServiceModel.fromFirestore(docSnap))
        .toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersHistory() async {
    final userPhone = await localDatasource.getUserPhone();
    final localUserId = await localDatasource.getUserId();
    final authUid = auth.currentUser?.uid;

    final List<Future<QuerySnapshot<Map<String, dynamic>>>> queries = [];

    if (userPhone != null && userPhone.isNotEmpty) {
      queries.add(firestore.collection('orders').where('phone', isEqualTo: userPhone).get());
      queries.add(firestore.collection('orders').where('customerPhone', isEqualTo: userPhone).get());
      queries.add(firestore.collection('orders').where('userId', isEqualTo: userPhone).get());
    }
    if (authUid != null && authUid.isNotEmpty) {
      queries.add(firestore.collection('orders').where('userId', isEqualTo: authUid).get());
    }
    if (localUserId != null && localUserId.isNotEmpty) {
      queries.add(firestore.collection('orders').where('userId', isEqualTo: localUserId).get());
    }

    final Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> uniqueDocs = {};

    if (queries.isNotEmpty) {
      final results = await Future.wait(
        queries.map((q) => q.catchError((_) => firestore.collection('orders').limit(0).get())),
      );

      for (final snapshot in results) {
        for (final doc in snapshot.docs) {
          uniqueDocs[doc.id] = doc;
        }
      }
    }

    final docList = uniqueDocs.values.toList();

    docList.sort((a, b) {
      final aData = a.data();
      final bData = b.data();
      final aTime = _getTimestamp(aData['createdAt'], aData['date']);
      final bTime = _getTimestamp(bData['createdAt'], bData['date']);
      return bTime.compareTo(aTime);
    });

    return docList.map((docSnap) {
      final data = docSnap.data();
      final items = data['items'] as List<dynamic>?;

      final id = (data['orderId'] != null && data['orderId'].toString().isNotEmpty)
          ? data['orderId'].toString()
          : docSnap.id;

      String title = 'RO Water Purifier Order';
      if (items != null && items.isNotEmpty && items[0] is Map && items[0]['name'] != null) {
        title = items[0]['name'].toString();
      } else if (data['title'] != null && data['title'].toString().isNotEmpty) {
        title = data['title'].toString();
      }

      String dateStr = '';
      if (data['date'] != null && data['date'].toString().isNotEmpty) {
        dateStr = data['date'].toString();
      } else if (data['createdAt'] != null) {
        if (data['createdAt'] is Timestamp) {
          dateStr = (data['createdAt'] as Timestamp).toDate().toString();
        } else {
          dateStr = data['createdAt'].toString();
        }
      }

      final amountNum = data['totalAmount'] ?? data['amount'];
      final amount = (amountNum as num?)?.toDouble() ?? 0.0;

      final status = (data['status'] ?? 'Pending').toString().toUpperCase();

      String? imageUrl;
      String? productId;

      if (items != null && items.isNotEmpty && items[0] is Map) {
        final firstItem = items[0] as Map;
        imageUrl = (firstItem['imageUrl'] ?? firstItem['photoUrl'] ?? firstItem['image'])?.toString();
        productId = (firstItem['productId'] ?? firstItem['id'])?.toString();
      }
      imageUrl ??= (data['imageUrl'] ?? data['photoUrl'] ?? data['image'])?.toString();
      productId ??= data['productId']?.toString();

      List<Map<String, dynamic>>? parsedItems;
      if (items != null) {
        parsedItems = items
            .whereType<Map>()
            .map((itemMap) => Map<String, dynamic>.from(itemMap))
            .toList();
      }

      final customerName = (data['customerName'] ?? data['name'] ?? data['userName'])?.toString();
      final phone = (data['phone'] ?? data['customerPhone'] ?? data['userPhone'])?.toString();

      String? address;
      if (data['address'] != null) {
        if (data['address'] is Map) {
          final addrMap = data['address'] as Map;
          address = addrMap['addressLine']?.toString() ?? addrMap['address']?.toString() ?? addrMap.values.join(', ');
        } else {
          address = data['address'].toString();
        }
      } else if (data['shippingAddress'] != null) {
        if (data['shippingAddress'] is Map) {
          final addrMap = data['shippingAddress'] as Map;
          address = addrMap['addressLine']?.toString() ?? addrMap['address']?.toString() ?? addrMap.values.join(', ');
        } else {
          address = data['shippingAddress'].toString();
        }
      }

      final paymentMethod = (data['paymentMethod'] ?? data['paymentType'])?.toString();
      final deliveryInstructions = (data['deliveryInstructions'] ?? data['instructions'] ?? data['notes'])?.toString();
      final subtotal = ((data['subtotal'] ?? data['subTotal']) as num?)?.toDouble();
      final shippingFee = ((data['shippingFee'] ?? data['deliveryFee'] ?? data['shippingCost']) as num?)?.toDouble();

      return OrderEntity(
        id: id,
        title: title,
        date: dateStr,
        amount: amount,
        status: status,
        imageUrl: imageUrl,
        productId: productId,
        items: parsedItems,
        customerName: customerName,
        phone: phone,
        address: address,
        paymentMethod: paymentMethod,
        deliveryInstructions: deliveryInstructions,
        subtotal: subtotal,
        shippingFee: shippingFee,
      );
    }).toList();
  }

  int _getTimestamp(dynamic createdAt, dynamic date) {
    if (createdAt is Timestamp) {
      return createdAt.millisecondsSinceEpoch;
    }
    if (createdAt is String && createdAt.isNotEmpty) {
      final dt = DateTime.tryParse(createdAt);
      if (dt != null) return dt.millisecondsSinceEpoch;
    }
    if (date is String && date.isNotEmpty) {
      final dt = DateTime.tryParse(date);
      if (dt != null) return dt.millisecondsSinceEpoch;
    }
    return 0;
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
    final userPhone = await localDatasource.getUserPhone();
    String customerName = 'App User';
    String phone = (userPhone != null && userPhone.isNotEmpty) ? userPhone : (userId != 'guest_user' ? userId : 'N/A');

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
        } else if (userPhone != null && userPhone.isNotEmpty) {
          final snap = await firestore.collection('customers').where('phone', isEqualTo: userPhone).limit(1).get();
          if (snap.docs.isNotEmpty) {
            final data = snap.docs.first.data();
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
