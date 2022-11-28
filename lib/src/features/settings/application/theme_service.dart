import 'package:shared_preferences/shared_preferences.dart';

import '../domain/theme_models.dart';

class ThemeService {
  final String appThemeKey = 'theme';

  Future<ThemeMode> loadSavedTheme() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    int? mode = prefs.getInt(appThemeKey);

    // user has not saved any app theme yet
    if (mode == null) return ThemeMode.light;

    //return savedtheme

    return ThemeMode.fromIndex(mode);
  }

  Future<bool> saveTheme(ThemeMode newThemeMode) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.setInt(appThemeKey, newThemeMode.index);
  }

  Future<bool> removeAppThemeInfo() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    return await prefs.remove(appThemeKey);
  }
}
