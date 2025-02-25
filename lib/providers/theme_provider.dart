import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode { light, dark }

// final themeModeProvider = StateNotfifierProvider


const themeKey = "theme";
const lightModeName = "light";

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(themeKey);
    state = (theme == null)
        ? ThemeMode.light
        : (theme == lightModeName)
            ? ThemeMode.light
            : ThemeMode.dark;
  }

  Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themeKey, mode.name);
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    final currentMode = prefs.getString(themeKey);
    final newMode =
        (currentMode == lightModeName) ? ThemeMode.dark : ThemeMode.light;
    await save(newMode);
  }
}
