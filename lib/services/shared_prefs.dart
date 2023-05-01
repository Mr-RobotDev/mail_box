import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String getString(String key) {
    return prefs.getString(key) ?? '';
  }

  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }
}
