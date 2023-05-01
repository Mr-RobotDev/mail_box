import 'package:hive/hive.dart';

final box = Hive.box('mail_box');

class HiveService {
  Future<void> init() async {
    await Hive.openBox(
      'mail_box',
      path: './mail_box',
    );
  }

  Future<void> save(String key, dynamic value) async {
    await box.put(key, value);
  }

  dynamic read(String key) {
    return box.get(key);
  }

  Future<void> delete(String key) async {
    await box.delete(key);
  }

  Future<void> clear() async {
    await box.clear();
  }
}
