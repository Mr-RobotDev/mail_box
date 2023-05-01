import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/common/ui_helpers.dart';
import 'package:mail_box/models/log.dart';
import 'package:mail_box/services/hive_service.dart';

class LogsProvider extends ChangeNotifier {
  final List<Log> logs = [];
  List<Log> searchedLogs = [];

  void loadLogs() {
    logs.clear();
    logs.addAll(HiveService.box.values.cast<Log>());
    searchedLogs = logs;
    notifyListeners();
  }

  void clearLogs(BuildContext context) {
    HiveService.box.clear();
    loadLogs();
    infoBox(context, 'Success', 'Logs cleared successfully', InfoBarSeverity.success);
  }

  void delete(Log log) {
    HiveService.box.delete(log.hashCode.toString());
    logs.remove(log);
    notifyListeners();
  }

  void search(String value) {
    searchedLogs = logs
        .where((element) =>
            element.logContent.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
