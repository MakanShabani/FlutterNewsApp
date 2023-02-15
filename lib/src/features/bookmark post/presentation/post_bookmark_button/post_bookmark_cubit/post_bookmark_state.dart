part of 'post_bookmark_cubit.dart';

@immutable
abstract class PostBookmarkState {
  const PostBookmarkState({
    required this.currentBookmarkingPosts,
    required this.isLocked,
  });
  final List<String> currentBookmarkingPosts;
  final bool isLocked;
}

class PostBookmarkInitialState extends PostBookmarkState {
  const PostBookmarkInitialState(
      {required super.currentBookmarkingPosts, required super.isLocked});
}

class PostBookmarkUpdatingPostBookmarkState extends PostBookmarkState {
  final Post post;

  const PostBookmarkUpdatingPostBookmarkState(
      {required this.post,
      required super.currentBookmarkingPosts,
      required super.isLocked});
}

class PostBookmarkUpdatedSuccessfullyState extends PostBookmarkState {
  final Post post;
  final bool newBookmarkValue;

  const PostBookmarkUpdatedSuccessfullyState(
      {required super.currentBookmarkingPosts,
      required this.post,
      required this.newBookmarkValue,
      required super.isLocked});
}

class PostBookmarkUpdateHasErrorState extends PostBookmarkState {
  final Post post;
  final ErrorModel error;
  const PostBookmarkUpdateHasErrorState(
      {required super.currentBookmarkingPosts,
      required this.post,
      required this.error,
      required super.isLocked});
}

class PostBookMarkLockvalueUpdated extends PostBookmarkState {
  const PostBookMarkLockvalueUpdated(
      {required super.currentBookmarkingPosts, required super.isLocked});
}
