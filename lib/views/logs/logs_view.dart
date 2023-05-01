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
            onPressed: () => logsProvider.clearLogs(context),
            style: ButtonStyle(
              backgroundColor: ButtonState.resolveWith(
                (states) => Colors.errorPrimaryColor,
              ),
              foregroundColor: ButtonState.resolveWith(
                (states) => Colors.white,
              ),
            ),
            child: const Text('Clear logs'),
          ),
          const SizedBox(width: 30),
        ],
      ),
      children: [
        TextFormBox(
          placeholder: 'Search',
          onChanged: (value) => logsProvider.search(value),
        ),
        const SizedBox(height: 10),
        ...logsProvider.searchedLogs
            .map(
              (e) => ListTile.selectable(
                tileColor: ButtonState.resolveWith(
                  (states) => e.error.isNotEmpty
                      ? Colors.errorPrimaryColor
                      : Colors.successPrimaryColor,
                ),
                title: Text(e.logContent),
                subtitle: Text(
                  DateFormat.yMMMMd().format(DateTime.parse(e.timeStamp)),
                ),
                trailing: IconButton(
                  icon: const Icon(FluentIcons.delete),
                  onPressed: () => logsProvider.delete(e),
                  style: ButtonStyle(
                    backgroundColor: ButtonState.resolveWith(
                      (states) => Colors.errorPrimaryColor,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
