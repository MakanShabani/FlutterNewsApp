part of 'posts_list_notifire_cubit.dart';

@immutable
abstract class PostsListNotifireCubitState {}

class PostsListNotifireCubitInitial extends PostsListNotifireCubitState {}

class PostsListNotifireCubitInsertPosts extends PostsListNotifireCubitState {
  final List<Post> posts;

  PostsListNotifireCubitInsertPosts({required this.posts});
}

class PostsListNotifireCubitRemovePost extends PostsListNotifireCubitState {
  final String postId;

  PostsListNotifireCubitRemovePost({required this.postId});
}
