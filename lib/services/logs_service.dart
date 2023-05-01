import 'dart:async';

import 'package:mail_box/services/hive_service.dart';
import 'package:mail_box/services/setup/setup.dart';

class LogsService {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void add(String value) async {
    await getIt<HiveService>().save(value, value);

    _controller.add(value);
  }

  void dispose() => _controller.close();
}
