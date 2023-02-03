part of 'tab_bar_cubit.dart';

@immutable
abstract class TabBarState {}

class TabBarInitial extends TabBarState {}

class TabBarShow extends TabBarState {}

class TabBarHide extends TabBarState {}
