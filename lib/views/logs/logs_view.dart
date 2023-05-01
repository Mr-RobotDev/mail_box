import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/views/logs/logs_provider.dart';
import 'package:provider/provider.dart';

class LogsView extends StatefulWidget {
  const LogsView({super.key});

  @override
  State<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  @override
  void initState() {
    context.read<LogsProvider>().loadLogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logsProvider = context.watch<LogsProvider>();
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Logs'),
      ),
      children: logsProvider.logs
          .map(
            (e) => ListTile.selectable(
              title: Text(e),
            ),
          )
          .toList(),
    );
  }
}
