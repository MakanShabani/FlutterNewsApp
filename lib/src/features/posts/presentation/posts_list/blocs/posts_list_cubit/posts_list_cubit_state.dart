part of 'posts_list_cubit.dart';

@immutable
abstract class PostsListCubitState {}

class PostsListCubitInitial extends PostsListCubitState {}

class PostsListCubitFetching extends PostsListCubitState {
  final List<Post>? currentPosts;
  final PagingOptionsDTO? lastLoadedPagingOptionsVm;
  final PagingOptionsDTO toLoadPagingOptionsVm;
  final String? categoryId;

  PostsListCubitFetching({
    this.currentPosts,
    this.lastLoadedPagingOptionsVm,
    required this.toLoadPagingOptionsVm,
    this.categoryId,
  });
}

class PostsListCubitFetchedSuccessfully extends PostsListCubitState {
  final List<Post>? previousPosts;
  final List<Post> newDownloadedPosts;
  final PagingOptionsDTO lastLoadedPagingOptionsVm;
  final String? categoryId;

  PostsListCubitFetchedSuccessfully({
    required this.previousPosts,
    required this.newDownloadedPosts,
    required this.lastLoadedPagingOptionsVm,
    this.categoryId,
  });
}

class PostsListCubitFetchingHasError extends PostsListCubitState {
  final List<Post>? currentPosts;
  final PagingOptionsDTO? lastLoadedPagingOptionsVm;
  final PagingOptionsDTO toLoadPagingOptionsVm;
  final String? categoryId;
  final ErrorModel error;

  PostsListCubitFetchingHasError({
    this.currentPosts,
    this.lastLoadedPagingOptionsVm,
    required this.toLoadPagingOptionsVm,
    this.categoryId,
    required this.error,
  });
}
