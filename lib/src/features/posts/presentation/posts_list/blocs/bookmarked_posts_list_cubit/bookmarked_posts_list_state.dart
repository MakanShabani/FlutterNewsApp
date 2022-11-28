part of 'bookmarked_posts_list_cubit.dart';

@immutable
abstract class BookmarkedPostsListState {}

class BookmarkedPostsListInitial extends BookmarkedPostsListState {}

class BookmarkedPostsListFetching extends BookmarkedPostsListState {
  final List<Post>? previousLoadedPosts;
  final PagingOptionsDTO? currentPagingOptionsDTO;
  final PagingOptionsDTO fetchingPagingOptionsDTO;
  final String? categoryId;

  BookmarkedPostsListFetching({
    this.previousLoadedPosts,
    this.currentPagingOptionsDTO,
    required this.fetchingPagingOptionsDTO,
    this.categoryId,
  });
}

class BookmarkedPostsListFetchingSuccessful extends BookmarkedPostsListState {
  final List<Post> posts;
  final PagingOptionsDTO currentPagingOptionsDTO;
  final String? categoryId;
  BookmarkedPostsListFetchingSuccessful(
      {required this.currentPagingOptionsDTO,
      required this.posts,
      this.categoryId});
}

class BookmarkedPostsListFetchingHasError extends BookmarkedPostsListState {
  final List<Post>? previousLoadedPosts;
  final PagingOptionsDTO? previousPagingOptionsDTO;
  final PagingOptionsDTO hadToLoadPagingOptionsDTO;
  final String? categoryId;
  final ErrorModel error;

  BookmarkedPostsListFetchingHasError({
    this.previousLoadedPosts,
    this.previousPagingOptionsDTO,
    required this.hadToLoadPagingOptionsDTO,
    required this.error,
    this.categoryId,
  });
}
