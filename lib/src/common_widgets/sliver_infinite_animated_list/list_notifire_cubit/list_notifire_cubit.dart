// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_notifire_cubit_state.dart';

class ListNotifireCubit<T> extends Cubit<ListNotifireCubitState> {
  ListNotifireCubit() : super(ListNotifireCubitInitial());

  void insertItems(List<T> newItems, bool insertToTheTop) {
    emit(ListNotifireCubitInsertNewItems<T>(
        newItems: newItems, insertToTheTop: insertToTheTop));
  }

  void removeItems(T itemToRemove) {
    emit(ListNotifireCubitRemoveItem<T>(itemToRemove: itemToRemove));
  }

  void modifyItem(int index, T modifiedItem, bool updateState) {
    emit(ListNotifireCubitItemModified<T>(
        index: index,
        modifiedItem: modifiedItem,
        updateListState: updateState));
  }

  void showLoading() {
    emit(ListNotifireCubitShowLoading());
  }

  void showError() {
    emit(ListNotifireCubitShowError());
  }
}
