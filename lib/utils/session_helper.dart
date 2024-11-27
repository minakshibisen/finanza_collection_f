import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static Future<void> saveSessionData(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value.toString());
  }

  static Future<String?> getSessionData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);  // Returns null if not found
  }

  static Future<void> removeSessionData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAllSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clears all data
  }

  static Future<bool> isSessionActive(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);  // Returns true if key exists
  }
}
