part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class InitializeCategoryEvent extends CategoryEvent {
  final PagingOptionsVm pagingOptionsVm;

  InitializeCategoryEvent({
    required this.pagingOptionsVm,
  });
}

class FetchMoreCategoryEvent extends CategoryEvent {
  final PagingOptionsVm pagingOptionsVm;

  FetchMoreCategoryEvent({
    required this.pagingOptionsVm,
  });
}
