// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/shared_preferences_service.dart';
import '../../models/theme_mode.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.sharedPreferencesService}) : super(ThemeInitial());

  final SharedPreferencesService sharedPreferencesService;

  void initialize() async {
    emit(ThemeInitializingState());

    //load saved theme from shared preferences

    ThemeMode? themeMode = await sharedPreferencesService.loadAppThemeMode();

    if (themeMode == null) {
      // user has not changed app theme yet
      // default theme is light

      emit(ThemeLightModeState());
      return;
    }

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

  void toggle() async {
    if (state is ThemeLightModeState) {
      //change app theme to dark
      emit(ThemeDarkModeState());
      //update theme flag in shared preferences
      await sharedPreferencesService.saveAppThemeMode(ThemeMode.dark);
      return;
    }

    if (state is ThemeDarkModeState) {
      //change app theme to light
      emit(ThemeLightModeState());
      //update theme flag in shared preferences
      await sharedPreferencesService.saveAppThemeMode(ThemeMode.light);
      return;
    }
  }
}
