part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class TabPageContentInitial extends PostState {}

class PostsInitializingState extends PostState {
  final PostCategory? currentCategory;

  PostsInitializingState({
    this.currentCategory,
  });
}

class PostsInitializingSuccessfullState extends PostState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm pagingOptionsVm;

  PostsInitializingSuccessfullState({
    this.currentCategory,
    required this.posts,
    required this.pagingOptionsVm,
  });
}

class PostsInitializingHasErrorState extends PostState {
  final PostCategory? currentCategory;
  final ErrorModel error;

  PostsInitializingHasErrorState({
    this.currentCategory,
    required this.error,
  });
}

class FetchingMorePostState extends PostState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm currentPagingOptions;
  final PagingOptionsVm fetchingPagingOptionsVm;

  FetchingMorePostState({
    this.currentCategory,
    required this.posts,
    required this.currentPagingOptions,
    required this.fetchingPagingOptionsVm,
  });
}

class FetchingMorePostSuccessfullState extends PostState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm pagingOptionsVm;

  FetchingMorePostSuccessfullState({
    this.currentCategory,
    required this.posts,
    required this.pagingOptionsVm,
  });
}

class FetchingMorePostHasErrorState extends PostState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm currentPagingOptions;
  final PagingOptionsVm errorPagingOptionsVm;
  final ErrorModel error;

  FetchingMorePostHasErrorState({
    required this.error,
    this.currentCategory,
    required this.posts,
    required this.currentPagingOptions,
    required this.errorPagingOptionsVm,
  });
}
