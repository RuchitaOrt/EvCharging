import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _keyUserId = "userId"; // or token key

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    return userId != null && userId.isNotEmpty;
  }
 /// 🔥 Get stored userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }
  Future<void> clearLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("📦 Local storage cleared");
}


  static const String _firstTimeKey = "is_first_time";

static Future<bool> isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_firstTimeKey) ?? true;
}

static Future<void> setFirstTimeDone() async {
  print("setFirstTimeDone");
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_firstTimeKey, false);
}


}
