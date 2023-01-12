// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tab_bar_state.dart';

class TabBarCubit extends Cubit<TabBarState> {
  TabBarCubit() : super(TabBarInitial());

  void showTabBar() {
    emit(TabBarShow());
  }

  void hideTabBar() {
    emit(TabBarHide());
  }
}
