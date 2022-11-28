part of 'post_bookmark_cubit.dart';

@immutable
abstract class PostBookmarkState {
  final List<String> currentBookmarkingPosts;
  const PostBookmarkState({
    required this.currentBookmarkingPosts,
  });
}

class PostBookmarkInitialState extends PostBookmarkState {
  const PostBookmarkInitialState({required super.currentBookmarkingPosts});
}

class PostBookmarkUpdatingPostBookmarkState extends PostBookmarkState {
  final String postId;

  const PostBookmarkUpdatingPostBookmarkState({
    required this.postId,
    required super.currentBookmarkingPosts,
  });
}

class PostBookmarkUpdatedSuccessfullyState extends PostBookmarkState {
  final String postId;
  final bool newBookmarkValue;

  const PostBookmarkUpdatedSuccessfullyState(
      {required super.currentBookmarkingPosts,
      required this.postId,
      required this.newBookmarkValue});
}

class PostBookmarkUpdateHasErrorState extends PostBookmarkState {
  final String postId;
  final ErrorModel error;
  const PostBookmarkUpdateHasErrorState({
    required super.currentBookmarkingPosts,
    required this.postId,
    required this.error,
  });
}
