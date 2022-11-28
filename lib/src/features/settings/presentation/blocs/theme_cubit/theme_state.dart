part of 'theme_cubit.dart';

@immutable
abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeInitializingState extends ThemeState {}

class ThemeDarkModeState extends ThemeState {}

class ThemeLightModeState extends ThemeState {}
