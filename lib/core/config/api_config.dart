class ApiConfig {
  static const String bulkSmsApiKey = String.fromEnvironment(
    'BULKSMSBD_API_KEY',
    defaultValue: 'sRoxc3uzjSe80UU13qwD',
  );
  static const String bulkSmsSenderId = String.fromEnvironment(
    'BULKSMSBD_SENDER_ID',
    defaultValue: '09617',
  );
  static const String bulkSmsEndpoint = 'https://bulksmsbd.net/api/smsapi';
}
