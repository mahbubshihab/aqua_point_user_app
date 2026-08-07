import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserPhone = 'user_phone';
  static const String keyUserId = 'user_id';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserPhone);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  Future<void> saveSession({
    required String phone,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, true);
    await prefs.setString(keyUserPhone, phone);
    await prefs.setString(keyUserId, userId);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsLoggedIn);
    await prefs.remove(keyUserPhone);
    await prefs.remove(keyUserId);
  }
}
