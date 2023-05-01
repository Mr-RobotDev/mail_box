import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/services/logs_service.dart';
import 'package:mail_box/services/setup.dart';

class LogsProvider extends ChangeNotifier {
  final List<String> logs = [];

  void loadLogs() {
    getIt<LogsService>().getLogs().forEach((element) {
      logs.add(element);
    });

    getIt<LogsService>().stream.listen((event) {
      logs.add(event);
      notifyListeners();
    });
  }
}
