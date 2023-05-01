import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/common/ui_helpers.dart';
import 'package:mail_box/models/log.dart';
import 'package:mail_box/services/hive_service.dart';

class LogsProvider extends ChangeNotifier {
  final List<Log> logs = [];

  void loadLogs() {
    logs.clear();
    logs.addAll(HiveService.box.values.cast<Log>());
    notifyListeners();
  }

  void clearLogs(BuildContext context) {
    HiveService.box.clear();
    loadLogs();
    infoBox(context, 'Success', 'Logs cleared successfully');
  }

  void delete(Log log) {
    HiveService.box.delete(log.hashCode.toString());
    logs.remove(log);
    notifyListeners();
  }
}
