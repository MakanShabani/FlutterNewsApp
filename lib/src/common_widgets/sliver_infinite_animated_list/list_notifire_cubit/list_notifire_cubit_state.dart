part of 'list_notifire_cubit.dart';

@immutable
abstract class ListNotifireCubitState {}

class ListNotifireCubitInitial extends ListNotifireCubitState {}

class ListNotifireCubitInsertNewItems<T> extends ListNotifireCubitState {
  final List<T> newItems;

  ListNotifireCubitInsertNewItems({required this.newItems});
}

class ListNotifireCubitRemoveItem<T> extends ListNotifireCubitState {
  final T itemToRemove;

  ListNotifireCubitRemoveItem({required this.itemToRemove});
}

class ListNotifireCubitItemModified<T> extends ListNotifireCubitState {
  ListNotifireCubitItemModified(
      {required this.index,
      required this.modifiedItem,
      required this.updateListState});
  final T modifiedItem;
  final bool updateListState;
  final int index;
}

class ListNotifireCubitShowLoading extends ListNotifireCubitState {}

class ListNotifireCubitShowError extends ListNotifireCubitState {}
