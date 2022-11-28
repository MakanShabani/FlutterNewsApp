part of 'post_category_cubit.dart';

@immutable
abstract class PostCategoryState {}

class PostCategoryInitial extends PostCategoryState {}

class PostCategoryFethcing extends PostCategoryState {
  PostCategoryFethcing({
    this.preiviousLoadedCategories,
    this.previousLoadedPagingOptions,
    required this.loadingPagingOptions,
  });
  final List<PostCategory>? preiviousLoadedCategories;
  final PagingOptionsDTO? previousLoadedPagingOptions;
  final PagingOptionsDTO loadingPagingOptions;
}

class PostCategoryFetchedSuccessfully extends PostCategoryState {
  PostCategoryFetchedSuccessfully(
      {required this.newPostCategories,
      required this.newLoadedPagingOptionsDTO,
      this.previousLoadedPagingOptionsDTO,
      this.previousPostCategories});
  final List<PostCategory> newPostCategories;
  final List<PostCategory>? previousPostCategories;
  final PagingOptionsDTO? previousLoadedPagingOptionsDTO;
  final PagingOptionsDTO newLoadedPagingOptionsDTO;
}

class PostCategoryFetchingHasError extends PostCategoryState {
  PostCategoryFetchingHasError(
      {this.preiviousLoadedCategories,
      this.previousLoadedPagingOptions,
      required this.loadingHasErrorPagingOptions,
      required this.error});
  final List<PostCategory>? preiviousLoadedCategories;
  final PagingOptionsDTO? previousLoadedPagingOptions;
  final PagingOptionsDTO loadingHasErrorPagingOptions;
  final ErrorModel error;
}
