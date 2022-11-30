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
  final Post post;

  const PostBookmarkUpdatingPostBookmarkState({
    required this.post,
    required super.currentBookmarkingPosts,
  });
}

class PostBookmarkUpdatedSuccessfullyState extends PostBookmarkState {
  final Post post;
  final bool newBookmarkValue;

  const PostBookmarkUpdatedSuccessfullyState(
      {required super.currentBookmarkingPosts,
      required this.post,
      required this.newBookmarkValue});
}

class PostBookmarkUpdateHasErrorState extends PostBookmarkState {
  final Post post;
  final ErrorModel error;
  const PostBookmarkUpdateHasErrorState({
    required super.currentBookmarkingPosts,
    required this.post,
    required this.error,
  });
}
