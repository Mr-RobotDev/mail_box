import 'package:fluent_ui/fluent_ui.dart';
import 'package:mail_box/views/settings/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Settings')),
      children: [
        Row(
          children: [
            Expanded(
              child: TextBox(
                placeholder: 'Email',
                controller: settingsProvider.emailController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextBox(
                placeholder: 'Password',
                suffix: IconButton(
                  icon: Icon(
                    settingsProvider.showPassword
                        ? FluentIcons.hide3
                        : FluentIcons.view,
                  ),
                  onPressed: settingsProvider.toggleShowPassword,
                ),
                obscureText: !settingsProvider.showPassword,
                controller: settingsProvider.passwordController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextBox(
          placeholder: 'Subject',
          controller: settingsProvider.subjectController,
        ),
        const SizedBox(height: 12),
        TextBox(
          placeholder: 'Body',
          maxLines: 10,
          controller: settingsProvider.bodyController,
        ),
        const SizedBox(height: 12),
        TextBox(
          placeholder: 'Processed Folder Path',
          controller: settingsProvider.folderPathController,
          onTap: () => settingsProvider.fetchFolderPath(context),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => settingsProvider.save(context),
          child: Text(settingsProvider.saveString),
        ),
      ],
    );
  }
}
