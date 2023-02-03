part of 'posts_list_cubit.dart';

@immutable
abstract class PostsListCubitState {
  const PostsListCubitState({this.categoryId, required this.posts});
  final String? categoryId;
  final List<Post> posts;
}

class PostsListCubitInitial extends PostsListCubitState {
  const PostsListCubitInitial({required super.posts, super.categoryId});
}

class PostsListCubitFetching extends PostsListCubitState {
  final PagingOptionsDTO toLoadPagingOptionsVm;

  const PostsListCubitFetching({
    required super.posts,
    required this.toLoadPagingOptionsVm,
    super.categoryId,
  });
}

class PostsListCubitFetchedSuccessfully extends PostsListCubitState {
  final PagingOptionsDTO lastLoadedPagingOptionsDto;

  const PostsListCubitFetchedSuccessfully({
    required super.posts,
    required this.lastLoadedPagingOptionsDto,
    super.categoryId,
  });
}

class PostsListCubitFetchingHasError extends PostsListCubitState {
  final PagingOptionsDTO failedLoadPagingOptionsVm;
  final ErrorModel error;

  const PostsListCubitFetchingHasError({
    required super.posts,
    required this.failedLoadPagingOptionsVm,
    super.categoryId,
    required this.error,
  });
}

class PostsListCubitPostHasBeenRemoved extends PostsListCubitState {
  final Post removedPost;

  const PostsListCubitPostHasBeenRemoved({
    required super.posts,
    required this.removedPost,
    super.categoryId,
  });
}

class PostsListCubitPostHasBeenAdded extends PostsListCubitState {
  final Post addedPost;

  const PostsListCubitPostHasBeenAdded({
    required super.posts,
    required this.addedPost,
    super.categoryId,
  });
}
