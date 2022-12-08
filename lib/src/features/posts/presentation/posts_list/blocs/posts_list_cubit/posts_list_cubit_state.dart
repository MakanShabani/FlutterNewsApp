part of 'posts_list_cubit.dart';

@immutable
abstract class PostsListCubitState {}

class PostsListCubitInitial extends PostsListCubitState {}

class PostsListCubitFetching extends PostsListCubitState {
  final List<Post> currentPosts;
  final PagingOptionsDTO toLoadPagingOptionsVm;
  final String? categoryId;

  PostsListCubitFetching({
    required this.currentPosts,
    required this.toLoadPagingOptionsVm,
    this.categoryId,
  });
}

class PostsListCubitFetchedSuccessfully extends PostsListCubitState {
  final List<Post> previousPosts;
  final List<Post> newDownloadedPosts;
  final String? categoryId;

  PostsListCubitFetchedSuccessfully({
    required this.previousPosts,
    required this.newDownloadedPosts,
    this.categoryId,
  });
}

class PostsListCubitFetchingHasError extends PostsListCubitState {
  final List<Post> currentPosts;
  final PagingOptionsDTO toLoadPagingOptionsVm;
  final String? categoryId;
  final ErrorModel error;

  PostsListCubitFetchingHasError({
    required this.currentPosts,
    required this.toLoadPagingOptionsVm,
    this.categoryId,
    required this.error,
  });
}

class PostsListCubitPostHasBeenRemoved extends PostsListCubitState {
  final List<Post> posts;
  final Post removedPost;
  final String? categoryId;

  PostsListCubitPostHasBeenRemoved({
    required this.posts,
    required this.removedPost,
    this.categoryId,
  });
}

class PostsListCubitPostHasBeenAdded extends PostsListCubitState {
  final List<Post> posts;
  final Post addedPost;
  final String? categoryId;

  PostsListCubitPostHasBeenAdded({
    required this.posts,
    required this.addedPost,
    this.categoryId,
  });
}
