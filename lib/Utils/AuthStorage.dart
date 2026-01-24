import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _keyUserId = "userId"; // or token key

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    return userId != null && userId.isNotEmpty;
  }

  Future<void> clearLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("📦 Local storage cleared");
}
}
