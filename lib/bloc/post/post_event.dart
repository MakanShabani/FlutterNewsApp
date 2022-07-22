part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class InitializePostsEvent extends PostEvent {
  final PostCategory? categoryToLoad;
  final PagingOptionsVm pagingOptions;

  InitializePostsEvent({
    this.categoryToLoad,
    required this.pagingOptions,
  });
}

class FetchMorePostsEvent extends PostEvent {
  final PostCategory? categoryToLoad;
  final PagingOptionsVm pagingOptions;

  FetchMorePostsEvent({
    required this.categoryToLoad,
    required this.pagingOptions,
  });
}
