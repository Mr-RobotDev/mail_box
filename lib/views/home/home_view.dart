import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:mail_box/views/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return ScaffoldPage.scrollable(
      bottomBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (provider.files.isNotEmpty) ...[
              SizedBox(
                width: 100,
                child: Button(
                  onPressed: provider.previousFile,
                  child: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: Button(
                  onPressed: provider.nextFile,
                  child: const Text('Next'),
                ),
              ),
            ],
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            Text(
              provider.sendingCount == 0
                  ? ''
                  : '${provider.sendingCount} emails in queue',
            ),
          ],
        ),
      ),
      header: Row(
        children: [
          const Expanded(
            child: PageHeader(
              title: Text('Home'),
            ),
          ),
          Button(
            onPressed: () => provider.pickFiles(context),
            style: ButtonStyle(
              backgroundColor: ButtonState.resolveWith(
                (states) => provider.files.isEmpty
                    ? Colors.red.withOpacity(0.1)
                    : Colors.successPrimaryColor,
              ),
            ),
            child:
                Text(provider.files.isEmpty ? 'Select Pdfs' : 'Pdfs Selected'),
          ),
          const SizedBox(width: 12),
          Button(
            onPressed: () => provider.pickUsers(context),
            style: ButtonStyle(
              backgroundColor: ButtonState.resolveWith(
                (states) => provider.users.isEmpty
                    ? Colors.red.withOpacity(0.1)
                    : Colors.successPrimaryColor,
              ),
            ),
            child: Text(
                provider.users.isEmpty ? 'Select Users' : 'Users Selected'),
          ),
          const SizedBox(width: 24),
        ],
      ),
      children: [
        Actions(
          actions: {
            EnterIntent: CallbackAction<EnterIntent>(
              onInvoke: (intent) => provider.send(context),
            ),
          },
          child: Shortcuts(
            shortcuts: {
              const SingleActivator(
                LogicalKeyboardKey.enter,
              ): EnterIntent(),
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormBox(
                    placeholder: 'Unit Number',
                    suffix: provider.unitNumberController.text.isNotEmpty
                        ? IconButton(
                            onPressed: provider.clearUnitNumber,
                            icon: const Icon(FluentIcons.clear),
                          )
                        : null,
                    controller: provider.unitNumberController,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => provider.send(context),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ),
        if (provider.files.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'File ${provider.currentFile + 1}/${provider.files.length}',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 550,
            child: SfPdfViewer.file(
              provider.files[provider.currentFile],
            ),
          ),
        ]
      ],
    );
  }
}

class EnterIntent extends Intent {}
