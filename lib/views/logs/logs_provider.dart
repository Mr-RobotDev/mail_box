import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/services/hive_service.dart';
class LogsProvider extends ChangeNotifier {
  final List<String> logs = [];

  void loadLogs() {
    logs.addAll(HiveService.box.values.cast<String>());
  }
}
