enum ThemeMode {
  light,
  dark;

  factory ThemeMode.fromIndex(int index) {
    if (index == 0) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }
}

extension ThemeModeExtensions on ThemeMode {
  String get stringValue => toString().split('.').last;
}
