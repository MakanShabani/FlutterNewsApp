// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../application/theme_service.dart';
import '../../../domain/theme_mode.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required ThemeService themeService})
      : _themeService = themeService,
        super(ThemeInitial());

  final ThemeService _themeService;

  void initialize() async {
    emit(ThemeInitializingState());

    //load saved theme from shared preferences

    ThemeMode themeMode = await _themeService.loadSavedTheme();

    if (themeMode == ThemeMode.light) {
      //light theme
      emit(ThemeLightModeState());
      return;
    }

    if (themeMode == ThemeMode.dark) {
      //dark theme
      emit(ThemeDarkModeState());
      return;
    }
  }

  void toggle() {
    if (state is ThemeLightModeState) {
      //update theme flag in shared preferences
      _themeService.saveTheme(ThemeMode.dark);

      //change app theme to dark

      emit(ThemeDarkModeState());

      return;
    }

    if (state is ThemeDarkModeState) {
      //change app theme to light
      //update theme flag in shared preferences
      _themeService.saveTheme(ThemeMode.light);
      emit(ThemeLightModeState());

      return;
    }
  }
}
