import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mail_box/views/home/home_view.dart';
import 'package:mail_box/views/logs/logs_view.dart';
import 'package:mail_box/views/main/main_view.dart';
import 'package:mail_box/views/settings/settings_view.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainView(
          shellContext: _shellNavigatorKey.currentContext,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsView(),
        ),
        GoRoute(
          path: '/logs',
          name: 'logs',
          builder: (context, state) => const LogsView(),
        ),
      ],
    ),
  ],
);
