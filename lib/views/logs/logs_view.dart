import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
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
    Future.delayed(Duration.zero, () {
      context.read<LogsProvider>().loadLogs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logsProvider = context.watch<LogsProvider>();
    return ScaffoldPage.scrollable(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: PageHeader(
              title: Text('Logs'),
            ),
          ),
          FilledButton(
            child: const Text('Clear logs'),
            onPressed: () => logsProvider.clearLogs(context),
          ),
          const SizedBox(width: 30),
        ],
      ),
      children: logsProvider.logs
          .map(
            (e) => ListTile.selectable(
              tileColor: ButtonState.resolveWith(
                (states) => e.error.isNotEmpty ? Colors.red : Colors.green,
              ),
              title: Text(e.logContent),
              subtitle: Text(
                DateFormat.yMMMMd().format(DateTime.parse(e.timeStamp)),
              ),
              trailing: IconButton(
                icon: const Icon(FluentIcons.delete),
                onPressed: () => logsProvider.delete(e),
              ),
            ),
          )
          .toList(),
    );
  }
}
