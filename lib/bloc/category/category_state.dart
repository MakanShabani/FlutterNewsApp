part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoriesInitializingState extends CategoryState {}

class CategoriesInitializationSuccessfullState extends CategoryState {
  final List<PostCategory> categories;
  final PagingOptionsVm pagingOptionsVm;

  CategoriesInitializationSuccessfullState({
    required this.categories,
    required this.pagingOptionsVm,
  });
}

class CategoriesInitializationHasErrorState extends CategoryState {
  final ErrorModel error;

  CategoriesInitializationHasErrorState({
    required this.error,
  });
}

class FetchingMoreCategoryState extends CategoryState {
  final List<PostCategory> categories;
  final PagingOptionsVm currentPagingOptions;
  final PagingOptionsVm fetchingPagingOptions;

  FetchingMoreCategoryState({
    required this.categories,
    required this.currentPagingOptions,
    required this.fetchingPagingOptions,
  });
}

class FetchMoreCategorySuccessfullState extends CategoryState {
  final List<PostCategory> categories;
  final PagingOptionsVm pagingOptionsVm;

  FetchMoreCategorySuccessfullState({
    required this.categories,
    required this.pagingOptionsVm,
  });
}

class FetchMoreCategoryHasErrorState extends CategoryState {
  final List<PostCategory> categories;
  final PagingOptionsVm currentPagingOptions;
  final PagingOptionsVm errorPagingOptions;
  final ErrorModel error;

  FetchMoreCategoryHasErrorState({
    required this.error,
    required this.currentPagingOptions,
    required this.errorPagingOptions,
    required this.categories,
  });
}
