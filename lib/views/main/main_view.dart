import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mail_box/app/app_router.dart';
import 'package:mail_box/app/app_theme.dart';
import 'package:mail_box/views/main/window_buttons.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class MainView extends StatefulWidget {
  const MainView(
      {super.key, required this.child, this.shellContext, required this.state});

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WindowListener {
  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      key: const Key('/'),
      icon: const Icon(FluentIcons.home),
      title: const Text('Home'),
      body: const SizedBox.shrink(),
      onTap: () {
        final RouteMatch lastMatch =
            router.routerDelegate.currentConfiguration.last;
        final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
            ? lastMatch.matches
            : router.routerDelegate.currentConfiguration;
        final String location = matchList.uri.toString();
        if (location != '/') router.pushNamed('home');
      },
    ),
    PaneItem(
      key: const Key('/logs'),
      icon: const Icon(FluentIcons.list),
      title: const Text('Logs'),
      body: const SizedBox.shrink(),
      onTap: () {
        final RouteMatch lastMatch =
            router.routerDelegate.currentConfiguration.last;
        final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
            ? lastMatch.matches
            : router.routerDelegate.currentConfiguration;
        final String location = matchList.uri.toString();
        if (location != '/logs') {
          router.pushNamed('logs');
        }
      },
    ),
    PaneItemSeparator(),
    PaneItem(
      key: const Key('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: const Text('Settings'),
      body: const SizedBox.shrink(),
      onTap: () {
        final RouteMatch lastMatch =
            router.routerDelegate.currentConfiguration.last;
        final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
            ? lastMatch.matches
            : router.routerDelegate.currentConfiguration;
        final String location = matchList.uri.toString();
        if (location != '/settings') {
          router.pushNamed('settings');
        }
      },
    ),
  ];

  int _calculateSelectedIndex() {
    final RouteMatch lastMatch =
        router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    int indexOriginal = originalItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == Key(location));

    if (indexOriginal == -1) {
      return originalItems
          .where((element) => element.key != null)
          .toList()
          .length;
    } else {
      return indexOriginal;
    }
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          return Align(
            alignment: AlignmentDirectional.center,
            child: Text('Mail Box', style: FluentTheme.of(context).typography.subtitle!
            ,),
          );
        }(),
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: ToggleSwitch(
                content: const Text('Dark Mode'),
                checked: FluentTheme.of(context).brightness.isDark,
                onChanged: (v) {
                  if (v) {
                    appTheme.mode = ThemeMode.dark;
                  } else {
                    appTheme.mode = ThemeMode.light;
                  }
                },
              ),
            ),
            if (!kIsWeb) const WindowButtons(),
          ],
        ),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        selected: _calculateSelectedIndex(),
        displayMode: appTheme.displayMode,
        items: originalItems,
        header: Center(
          child: Image.asset(
            'assets/icons/mail.png',
            width: 48,
            height: 48,
          ),
        ),
        indicator: () {
          return const StickyNavigationIndicator();
        }(),
      ),
    );
  }

  @override
  void onWindowClose() async {
    await showDialog(
      context: context,
      builder: (_) {
        return ContentDialog(
          title: const Text('Confirm close'),
          content: const Text(
              'Please verify on home view if there are any unsent emails before closing the window.'),
          actions: [
            FilledButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                windowManager.destroy();
              },
            ),
            Button(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
