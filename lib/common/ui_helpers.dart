import 'package:fluent_ui/fluent_ui.dart';

void infoBox(BuildContext context, String title, String content) {
  displayInfoBar(
    context,
    builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: Text(content),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.warning,
      );
    },
  );
}
