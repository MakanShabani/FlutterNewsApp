part of 'posts_list_bloc.dart';

@immutable
abstract class PostsListState {
  final String? categoryId;
  final List<Post> posts;
  final PagingOptionsVm pagingOptionsVm;
  const PostsListState({
    this.categoryId,
    required this.posts,
    required this.pagingOptionsVm,
  });
}

class PostsListInitial extends PostsListState {
  const PostsListInitial({
    required super.posts,
    required super.pagingOptionsVm,
    super.categoryId,
  });
}

class PostsListInitializingState extends PostsListState {
  const PostsListInitializingState({
    super.categoryId,
    required super.pagingOptionsVm,
    required super.posts,
  });
}

class PostsListInitializingSuccessfulState extends PostsListState {
  const PostsListInitializingSuccessfulState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
  });
}

class PostsListInitializingHasErrorState extends PostsListState {
  final ErrorModel error;

  const PostsListInitializingHasErrorState({
    super.categoryId,
    required super.pagingOptionsVm,
    required super.posts,
    required this.error,
  });
}

class PostsListFetchingMorePostState extends PostsListState {
  final PagingOptionsVm fetchingPagingOptionsVm;

  const PostsListFetchingMorePostState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
    required this.fetchingPagingOptionsVm,
  });
}

class PostsListFetchingMorePostSuccessfulState extends PostsListState {
  const PostsListFetchingMorePostSuccessfulState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
  });
}

class PostsListFetchingMorePostHasErrorState extends PostsListState {
  final PagingOptionsVm errorPagingOptionsVm;
  final ErrorModel error;

  const PostsListFetchingMorePostHasErrorState({
    required this.error,
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
    required this.errorPagingOptionsVm,
  });
}

class PostsListPostBookmarkUpdated extends PostsListState {
  const PostsListPostBookmarkUpdated({
    required super.posts,
    required super.pagingOptionsVm,
    super.categoryId,
  });
}
