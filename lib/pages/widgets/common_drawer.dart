import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonDrawer extends HookConsumerWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inDarkMode = ref.watch(darkThemeProvider);
    final darkModeNotifier = ref.read(darkThemeProvider.notifier);
    return Drawer(
      child: Column(
        spacing: 15.0,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(
            child: Text(
              t.options.title,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.0,
            children: [
              Text(t.options.dark_mode.label),
              Switch(
                value: inDarkMode,
                onChanged: (newValue) => darkModeNotifier.toggle(),
              )
            ],
          )
        ],
      ),
    );
  }
}
