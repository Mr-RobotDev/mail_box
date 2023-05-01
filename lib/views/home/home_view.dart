import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/views/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<HomeProvider>().startFocusRequestTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return ScaffoldPage.scrollable(
      bottomBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              provider.sendingCount == 0
                  ? 'Ready'
                  : 'Sending ${provider.sendingCount}...',
              style: FluentTheme.of(context).typography.subtitle,
            ),
          ],
        ),
      ),
      header: const PageHeader(
        title: Text('Home'),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextFormBox(
                placeholder: 'Unit Number',
                focusNode: provider.unitNumberFocusNode,
                onFieldSubmitted: (value) => provider.send(context),
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
        if (provider.files.isNotEmpty && provider.users.isNotEmpty)
          const SizedBox(height: 12),
        if (provider.files.isNotEmpty && provider.users.isNotEmpty)
          Text(
            'File ${provider.currentFile + 1}/${provider.files.length}',
            style: FluentTheme.of(context).typography.subtitle,
          ),
        const SizedBox(height: 12),
        provider.files.isEmpty || provider.users.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    onPressed: () => provider.pickFiles(context),
                    child: Text(provider.files.isEmpty
                        ? 'Select Pdfs'
                        : 'Pdfs Selected'),
                  ),
                  const SizedBox(width: 12),
                  Button(
                    onPressed: () => provider.pickUsers(context),
                    child: Text(provider.users.isEmpty
                        ? 'Select Users'
                        : 'Users Selected'),
                  ),
                ],
              )
            : SizedBox(
                height: 550,
                child: SfPdfViewer.file(
                  provider.files[provider.currentFile],
                ),
              ),
      ],
    );
  }
}
