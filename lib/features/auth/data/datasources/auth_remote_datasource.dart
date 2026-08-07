import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRemoteDatasource {
  final FirebaseFirestore _firestore;

  AuthRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveOrUpdateCustomer({
    required String phone,
    required String userId,
  }) async {
    try {
      final docRef = _firestore.collection('customers').doc(phone);
      final docSnapshot = await docRef.get();

      final now = FieldValue.serverTimestamp();

      if (docSnapshot.exists) {
        await docRef.update({
          'lastLoginAt': now,
          'status': 'active',
        });
        log('Updated existing customer record in Firestore for $phone');
      } else {
        await docRef.set({
          'id': userId,
          'phoneNumber': phone,
          'name': 'Customer ${phone.length >= 4 ? phone.substring(phone.length - 4) : phone}',
          'role': 'customer',
          'status': 'active',
          'rewardPoints': 100,
          'createdAt': now,
          'lastLoginAt': now,
        });
        log('Created new customer record in Firestore for $phone');
      }
    } catch (e) {
      log('Error creating/updating Firestore customer record: $e');
      // Non-blocking fallback so user can still access app if offline or rules block write
    }
  }
}
