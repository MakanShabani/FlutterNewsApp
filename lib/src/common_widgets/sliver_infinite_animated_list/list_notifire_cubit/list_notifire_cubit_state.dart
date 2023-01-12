part of 'list_notifire_cubit.dart';

@immutable
abstract class ListNotifireCubitState {}

class ListNotifireCubitInitial extends ListNotifireCubitState {}

class ListNotifireCubitInsertNewItems extends ListNotifireCubitState {
  final List<dynamic> newItems;

  ListNotifireCubitInsertNewItems({required this.newItems});
}

class ListNotifireCubitRemoveItem extends ListNotifireCubitState {
  final dynamic itemToRemove;

  ListNotifireCubitRemoveItem({required this.itemToRemove});
}

class ListNotifireCubitItemModified extends ListNotifireCubitState {
  ListNotifireCubitItemModified(
      {required this.index,
      required this.modifiedItem,
      required this.updateListState});
  final dynamic modifiedItem;
  final bool updateListState;
  final int index;
}

class ListNotifireCubitShowLoading extends ListNotifireCubitState {}

class ListNotifireCubitShowError extends ListNotifireCubitState {}
