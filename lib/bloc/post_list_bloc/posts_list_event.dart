part of 'posts_list_bloc.dart';

@immutable
abstract class PostsListEvent {}

class PostsListInitializeEvent extends PostsListEvent {
  final AuthenticatedUserModel? user;
  PostsListInitializeEvent({this.user});
}

class PostsListFetchMorePostsEvent extends PostsListEvent {
  final AuthenticatedUserModel? user;

  PostsListFetchMorePostsEvent({this.user});
}

class PostsListUpdatePostBookmarkEvent extends PostsListEvent {
  final String postId;
  final bool newBookmarkStatus;

  PostsListUpdatePostBookmarkEvent({
    required this.postId,
    required this.newBookmarkStatus,
  });
}
