class ApiConfig {
  static const String bulkSmsApiKey = String.fromEnvironment(
    'BULKSMSBD_API_KEY',
    defaultValue: 'g0Szw5nu85jMzETms1GM',
  );
  static const String bulkSmsSenderId = String.fromEnvironment(
    'BULKSMSBD_SENDER_ID',
    defaultValue: '8809648910347',
  );
  static const String bulkSmsEndpoint = 'https://bulksmsbd.net/api/smsapi';
}
