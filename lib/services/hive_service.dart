import 'package:hive/hive.dart';


class HiveService {
  static Box box = Hive.box('app_logs');
  
  static Future<void> init() async {
    box = await Hive.openBox(
      'app_logs',
      path: './',
    );
  }

  static Future<void> save(String key, dynamic value) async {
    await box.put(key, value);
  }

  static dynamic read(String key) {
    return box.get(key);
  }

  static Future<void> delete(String key) async {
    await box.delete(key);
  }

  static Future<void> clear() async {
    await box.clear();
  }
}
