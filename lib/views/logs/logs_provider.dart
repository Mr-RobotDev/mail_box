import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/services/hive_service.dart';
import 'package:mail_box/services/logs_service.dart';
import 'package:mail_box/services/setup/setup.dart';

class LogsProvider extends ChangeNotifier {
  final List<String> logs = [];

  void loadLogs() {
    logs.addAll(box.values.cast<String>());

    getIt<LogsService>().stream.listen((event) {
      logs.add(event);
      notifyListeners();
    });
  }
}
