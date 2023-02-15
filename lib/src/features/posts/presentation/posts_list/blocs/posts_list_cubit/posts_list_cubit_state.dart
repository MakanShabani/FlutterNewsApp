part of 'posts_list_cubit.dart';

@immutable
abstract class PostsListCubitState {
  const PostsListCubitState({this.categoryId, required this.posts});
  final String? categoryId;
  final List<Post> posts;
}

class PostsListCubitInitial extends PostsListCubitState {
  const PostsListCubitInitial({required super.posts, super.categoryId});
}

class PostsListCubitFetching extends PostsListCubitState {
  const PostsListCubitFetching({
    required super.posts,
    super.categoryId,
  });
}

class PostsListCubitFetchedSuccessfully extends PostsListCubitState {
  const PostsListCubitFetchedSuccessfully(
      {required super.posts, super.categoryId, required this.fetchedPosts});

  final List<Post> fetchedPosts;
}

class PostsListCubitFetchingHasError extends PostsListCubitState {
  final ErrorModel error;

  const PostsListCubitFetchingHasError({
    required super.posts,
    super.categoryId,
    required this.error,
  });
}

class PostsListCubitPostHasBeenRemoved extends PostsListCubitState {
  final Post removedPost;

  const PostsListCubitPostHasBeenRemoved({
    required super.posts,
    required this.removedPost,
    super.categoryId,
  });
}

class PostsListCubitPostHasBeenAdded extends PostsListCubitState {
  const PostsListCubitPostHasBeenAdded({
    required super.posts,
    required this.addedPosts,
    required super.categoryId,
  });
  final List<Post> addedPosts;
}

class PostsListCubitIsEmpty extends PostsListCubitState {
  const PostsListCubitIsEmpty({
    required super.posts,
    super.categoryId,
  });
}

class PostsListNoMorePostsToFetch extends PostsListCubitState {
  const PostsListNoMorePostsToFetch({
    required super.posts,
    super.categoryId,
  });
}
