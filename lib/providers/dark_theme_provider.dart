import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dark_theme_provider.g.dart';

const darkThemeKey = "darkTheme";

@riverpod
class DarkTheme extends _$DarkTheme {
  @override
  bool build() {
    load();
    return false;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool(darkThemeKey);
    state = isDarkTheme == true;
  }

  Future<void> save(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkThemeKey, newValue);
  }

  void toggle() {
    state = !state;
    save(state);
  }

  bool isDarkMode() => state; 
}
