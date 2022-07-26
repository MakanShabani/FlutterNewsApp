part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostTogglingBookmarkState extends PostState {
  final String postId;
  PostTogglingBookmarkState({required this.postId});
}

class PostTogglingPostBookmarkSuccessfullState extends PostState {
  final String postId;
  PostTogglingPostBookmarkSuccessfullState({required this.postId});
}

class PostTogglingPostBookmarkHasErrorState extends PostState {
  final String postId;
  final ErrorModel errorModel;
  PostTogglingPostBookmarkHasErrorState({
    required this.postId,
    required this.errorModel,
  });
}
