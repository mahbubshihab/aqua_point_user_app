import 'dart:convert';
import 'dart:developer';
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

class BulkSmsService {
  /// Sanitize Bangladeshi phone numbers to format: 8801XXXXXXXXX or 01XXXXXXXXX
  static String sanitizePhoneNumber(String rawNumber) {
    String clean = rawNumber.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('880')) {
      return clean;
    } else if (clean.startsWith('0')) {
      return '88$clean';
    } else if (clean.length == 10 && clean.startsWith('1')) {
      return '880$clean';
    }
    return clean;
  }

  /// Sends Non-Masking OTP SMS via BulkSMSBD API over HTTPS
  Future<BulkSmsResponse> sendOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final targetNumber = sanitizePhoneNumber(phoneNumber);
    final message = 'Your AQUA POINT OTP is $otpCode';

    final uri = Uri.parse(ApiConfig.bulkSmsEndpoint).replace(queryParameters: {
      'api_key': ApiConfig.bulkSmsApiKey,
      'type': 'text',
      'number': targetNumber,
      'senderid': ApiConfig.bulkSmsSenderId,
      'message': message,
    });

    log('BulkSMSBD Request URI: $uri');

    try {
      final response = await http.get(uri);
      log('BulkSMSBD HTTP Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return BulkSmsResponse.fromJson(data);
      } else {
        return BulkSmsResponse(
          responseCode: response.statusCode,
          successMessage: '',
          errorMessage: 'Server HTTP Error ${response.statusCode}',
        );
      }
    } catch (e) {
      log('BulkSMSBD Exception: $e');
      return BulkSmsResponse(
        responseCode: 500,
        successMessage: '',
        errorMessage: 'Network exception: $e',
      );
    }
  }
}
