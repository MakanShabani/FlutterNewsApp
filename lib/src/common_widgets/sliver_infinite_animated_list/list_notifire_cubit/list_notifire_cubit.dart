// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_notifire_cubit_state.dart';

class ListNotifireCubit extends Cubit<ListNotifireCubitState> {
  ListNotifireCubit() : super(ListNotifireCubitInitial());

  void insertItems(List<dynamic> newItems) {
    emit(ListNotifireCubitInsertNewItems(newItems: newItems));
  }

  void removeItems(dynamic itemToRemove) {
    emit(ListNotifireCubitRemoveItem(itemToRemove: itemToRemove));
  }

  void modifyItem(int index, dynamic modifiedItem, bool updateState) {
    emit(ListNotifireCubitItemModified(
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
