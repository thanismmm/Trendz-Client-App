import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendz_customer/Models/usermodel.dart';

class StorageService {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", user.toJson().toString());
  }

  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("user");
    if (userData != null) {
      return User.fromJson(userData as Map<String, dynamic>);
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }
}
