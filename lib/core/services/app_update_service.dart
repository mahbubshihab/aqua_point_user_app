import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUpdateService {
  static const String _keyInstalledVersion = 'installed_app_version';
  static const String currentAppVersion = '1.0.0+1';

  static Future<void> checkAndPurgeStaleDataOnUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getString(_keyInstalledVersion);

    if (savedVersion == null || savedVersion != currentAppVersion) {
      await prefs.clear();
      try {
        await FirebaseFirestore.instance.clearPersistence();
      } catch (_) {}
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      await prefs.setString(_keyInstalledVersion, currentAppVersion);
    }
  }
}
