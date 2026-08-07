import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/bulk_sms_service.dart';

class AuthRemoteDatasource {
  final FirebaseFirestore _firestore;

  AuthRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveOtpVerification({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final sanitizedPhone = sanitizePhone(phoneNumber);
    try {
      final docRef = _firestore.collection('otp_verifications').doc(sanitizedPhone);
      final now = DateTime.now();
      final expiresAt = Timestamp.fromDate(now.add(const Duration(minutes: 5)));

      await docRef.set({
        'phoneNumber': sanitizedPhone,
        'otpCode': otpCode,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': expiresAt,
        'isUsed': false,
      });
      log('Saved OTP verification record in Firestore for $sanitizedPhone');
    } catch (e) {
      log('Error saving OTP verification to Firestore: $e');
    }
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String inputOtp,
    String? expectedOtp,
  }) async {
    final sanitizedPhone = sanitizePhone(phoneNumber);
    try {
      final docRef = _firestore.collection('otp_verifications').doc(sanitizedPhone);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data();
        if (data != null) {
          final storedOtp = data['otpCode']?.toString();
          final isUsed = data['isUsed'] == true;
          final expiresAt = data['expiresAt'];
          DateTime? expiryTime;
          if (expiresAt is Timestamp) {
            expiryTime = expiresAt.toDate();
          } else if (expiresAt is String) {
            expiryTime = DateTime.tryParse(expiresAt);
          }

          final now = DateTime.now();
          final isNotExpired = expiryTime != null && expiryTime.isAfter(now);

          if (storedOtp == inputOtp.trim() && !isUsed && isNotExpired) {
            await docRef.update({'isUsed': true});
            return true;
          }
        }
      }

      final querySnap = await _firestore
          .collection('otp_verifications')
          .where('phoneNumber', isEqualTo: sanitizedPhone)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (querySnap.docs.isNotEmpty) {
        final doc = querySnap.docs.first;
        final data = doc.data();
        final storedOtp = data['otpCode']?.toString();
        final isUsed = data['isUsed'] == true;
        final expiresAt = data['expiresAt'];
        DateTime? expiryTime;
        if (expiresAt is Timestamp) {
          expiryTime = expiresAt.toDate();
        }

        final now = DateTime.now();
        final isNotExpired = expiryTime != null && expiryTime.isAfter(now);

        if (storedOtp == inputOtp.trim() && !isUsed && isNotExpired) {
          await doc.reference.update({'isUsed': true});
          return true;
        }
      }
    } catch (e) {
      log('Error verifying OTP in Firestore: $e');
    }

    if (expectedOtp != null && expectedOtp.isNotEmpty && inputOtp.trim() == expectedOtp.trim()) {
      return true;
    }

    return false;
  }

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
