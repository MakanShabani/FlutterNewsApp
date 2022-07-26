part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class PostToggleBookmarkEvent extends PostEvent {
  final String postId;

  PostToggleBookmarkEvent({required this.postId});
}
