import 'dart:io' show Platform;

import 'package:basicchessendgamestrainer/data/stockfish_manager.dart';
import 'package:basicchessendgamestrainer/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  final isDesktop = Platform.isWindows ||
      Platform.isMacOS ||
      Platform.isLinux ||
      Platform.isFuchsia;
  final home = isDesktop ? const AppDesktop() : const AppMobile();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  stockfishManager.init();
  runApp(ProviderScope(child: TranslationProvider(child: home)));
}

class AppMobile extends StatelessWidget {
  const AppMobile({super.key});

  void _handleExit(bool didPop) {
    if (didPop) return;
    stockfishManager.dispose();
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: PopScope(
        canPop: false,
        onPopInvoked: _handleExit,
        child: MaterialApp(
          onGenerateTitle: (context) => t.misc.app_title,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: FlexThemeData.light(scheme: FlexScheme.greenM3),
          darkTheme: FlexThemeData.dark(scheme: FlexScheme.blueWhale),
          themeMode: ThemeMode.system,
          home: const HomePage(),
        ),
      ),
    );
  }
}

class AppDesktop extends StatefulWidget {
  const AppDesktop({super.key});

  @override
  State<AppDesktop> createState() => _AppDesktopState();
}

class _AppDesktopState extends State<AppDesktop> with WindowListener {
  void _handleExit(bool didPop) {
    if (didPop) return;
    stockfishManager.dispose();
    SystemNavigator.pop();
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() {
    stockfishManager.dispose();
    super.onWindowClose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: PopScope(
        canPop: false,
        onPopInvoked: _handleExit,
        child: MaterialApp(
          onGenerateTitle: (context) => t.misc.app_title,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: FlexThemeData.light(scheme: FlexScheme.greenM3),
          darkTheme: FlexThemeData.dark(scheme: FlexScheme.blueWhale),
          themeMode: ThemeMode.system,
          home: const HomePage(),
        ),
      ),
    );
  }
}
