part of 'bookmarked_posts_list_cubit.dart';

@immutable
abstract class BookmarkedPostsListState {}

class BookmarkedPostsListInitial extends BookmarkedPostsListState {}

class BookmarkedPostsListFetching extends BookmarkedPostsListState {
  final List<Post>? previousLoadedPosts;
  final PagingOptionsVm? currentPagingOptionsVM;
  final PagingOptionsVm fetchingPagingOptionsVM;
  final String? categoryId;

  BookmarkedPostsListFetching({
    this.previousLoadedPosts,
    this.currentPagingOptionsVM,
    required this.fetchingPagingOptionsVM,
    this.categoryId,
  });
}

class BookmarkedPostsListFetchingSuccessful extends BookmarkedPostsListState {
  final List<Post> posts;
  final PagingOptionsVm currentPagingOptionsVM;
  final String? categoryId;
  BookmarkedPostsListFetchingSuccessful(
      {required this.currentPagingOptionsVM,
      required this.posts,
      this.categoryId});
}

class BookmarkedPostsListFetchingHasError extends BookmarkedPostsListState {
  final List<Post>? previousLoadedPosts;
  final PagingOptionsVm? previousPagingOptionsVM;
  final PagingOptionsVm hadToLoadPagingOptionsVM;
  final String? categoryId;
  final ErrorModel error;

  BookmarkedPostsListFetchingHasError({
    this.previousLoadedPosts,
    this.previousPagingOptionsVM,
    required this.hadToLoadPagingOptionsVM,
    required this.error,
    this.categoryId,
  });
}
