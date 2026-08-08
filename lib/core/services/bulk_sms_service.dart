import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class BulkSmsResponse {
  final int responseCode;
  final String successMessage;
  final String errorMessage;
  final String? messageId;

  BulkSmsResponse({
    required this.responseCode,
    required this.successMessage,
    required this.errorMessage,
    this.messageId,
  });

  bool get isSuccess => responseCode == 202;

  factory BulkSmsResponse.fromJson(Map<String, dynamic> json) {
    return BulkSmsResponse(
      responseCode: json['response_code'] is int
          ? json['response_code']
          : int.tryParse(json['response_code']?.toString() ?? '') ?? 0,
      successMessage: json['success_message']?.toString() ?? '',
      errorMessage: json['error_message']?.toString() ?? '',
      messageId: json['message_id']?.toString(),
    );
  }
}

/// Sanitizes raw Bangladeshi phone number input:
/// - Strips non-digits
/// - Removes leading country code '880' -> '0...'
/// - Normalizes 10-digit '1XXXXXXXXX' by prepending '0' -> '01XXXXXXXXX'
String sanitizePhone(String rawInput) {
  String clean = rawInput.replaceAll(RegExp(r'\D'), '');
  if (clean.startsWith('880')) {
    clean = clean.substring(3);
  }
  if (clean.startsWith('1') && clean.length == 10) {
    clean = '0$clean'; // prepend leading 0
  }
  return clean;
}

class BulkSmsService {
  /// Sanitize Bangladeshi phone numbers to format: 8801XXXXXXXXX or 01XXXXXXXXX
  static String sanitizePhoneNumber(String rawNumber) {
    String clean = sanitizePhone(rawNumber);
    if (clean.startsWith('0')) {
      return '88$clean';
    }
    return clean;
  }

  /// List of candidate sender IDs to attempt if primary sender ID fails
  static const List<String> senderIdCandidates = [
    '8809648910347',
    '8809617885841',
    '09617',
    'aquapoint45',
  ];

  /// Sends Non-Masking OTP SMS via BulkSMSBD API over HTTPS/HTTP with fallbacks
  Future<BulkSmsResponse> sendOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final targetNumber = sanitizePhoneNumber(phoneNumber);
    final message = '$otpCode is your Aqua Point verification code. Valid for 5 minutes. Never share this with anyone.';

    final baseEndpoints = [
      'https://bulksmsbd.net/api/smsapi',
      'http://bulksmsbd.net/api/smsapi',
    ];

    final senderIdsToTry = <String>{
      ApiConfig.bulkSmsSenderId,
      ...senderIdCandidates,
    }.toList();

    BulkSmsResponse? lastResponse;

    for (final endpoint in baseEndpoints) {
      for (final senderId in senderIdsToTry) {
        try {
          final response = await http.post(
            Uri.parse(endpoint),
            body: {
              'api_key': ApiConfig.bulkSmsApiKey,
              'type': 'text',
              'number': targetNumber,
              'senderid': senderId,
              'message': message,
            },
          ).timeout(const Duration(seconds: 10));
          log('BulkSMSBD HTTP Status: ${response.statusCode}, Body: ${response.body}');
          debugPrint('[BulkSMSBD] HTTP ${response.statusCode}: ${response.body}');

          if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            final parsedResponse = BulkSmsResponse.fromJson(data);

            if (parsedResponse.isSuccess) {
              log('BulkSMSBD SMS delivered successfully! MsgID: ${parsedResponse.messageId}');
              return parsedResponse;
            } else {
              log('BulkSMSBD API Error (${parsedResponse.responseCode}): ${parsedResponse.errorMessage}');
              lastResponse = parsedResponse;
            }
          } else {
            lastResponse = BulkSmsResponse(
              responseCode: response.statusCode,
              successMessage: '',
              errorMessage: 'HTTP Server Error ${response.statusCode}',
            );
          }
        } catch (e) {
          log('BulkSMSBD Connection Exception for $endpoint: $e');
          debugPrint('[BulkSMSBD] Exception: $e');
          lastResponse = BulkSmsResponse(
            responseCode: 500,
            successMessage: '',
            errorMessage: 'Network exception: $e',
          );
        }
      }
    }

    return lastResponse ??
        BulkSmsResponse(
          responseCode: 500,
          successMessage: '',
          errorMessage: 'Unable to deliver SMS via BulkSMSBD',
        );
  }
}

