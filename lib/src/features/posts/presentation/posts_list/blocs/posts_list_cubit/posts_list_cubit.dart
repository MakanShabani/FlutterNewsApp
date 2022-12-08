// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import '../../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../application/posts_services.dart';
import '../../../../domain/posts_models.dart';

part 'posts_list_cubit_state.dart';

class PostsListCubit extends Cubit<PostsListCubitState> {
  PostsListCubit({
    required PostsListService postsListService,
    required this.haowManyPostFetchEachTime,
  })  : _postsListService = postsListService,
        assert(haowManyPostFetchEachTime >= 10),
        super(PostsListCubitInitial());

  final PostsListService _postsListService;
  final int haowManyPostFetchEachTime;

  void fetch(String? userToken, String? categoryId,
      bool? loadOnlyBookmarkedPosts) async {
    if (state is PostsListCubitFetching) {
      return;
    }

    //define pagingOptionsVm to use in fetching
    List<Post> currentPosts = allPosts();
    PagingOptionsDTO toFetchPagingOptions = PagingOptionsDTO(
        offset: currentPosts.length, limit: haowManyPostFetchEachTime);
    emit(PostsListCubitFetching(
      toLoadPagingOptionsVm: toFetchPagingOptions,
      categoryId: categoryId,
      currentPosts: currentPosts,
    ));

    //load posts
    ResponseDTO<List<Post>> fetchingPostsResponse;

    //fetch only user bookmarked post or all posts
    if (loadOnlyBookmarkedPosts != null &&
        loadOnlyBookmarkedPosts &&
        userToken != null) {
      //fetch user bookmarked posts
      fetchingPostsResponse = await _postsListService.getUserBookmarkedPosts(
          userToken: userToken, pagingOptionsDTO: toFetchPagingOptions);
    } else {
      //fetch all posts(including user bookmarked posts)
      fetchingPostsResponse = await _postsListService.getPosts(
          pagingOptionsDTO: toFetchPagingOptions,
          userToken: userToken,
          categoryId: categoryId);
    }

    if (fetchingPostsResponse.statusCode != 200) {
      emit(PostsListCubitFetchingHasError(
          toLoadPagingOptionsVm: toFetchPagingOptions,
          currentPosts: currentPosts,
          categoryId: categoryId,
          error: fetchingPostsResponse.error!));
      return;
    }

    emit(PostsListCubitFetchedSuccessfully(
      previousPosts: currentPosts,
      newDownloadedPosts: fetchingPostsResponse.data!,
      categoryId: categoryId,
    ));
  }

  void removePostFromList({required String postId}) {
    List<Post> currentPosts = allPosts();
    Post removedPost =
        currentPosts.removeAt(currentPosts.indexWhere((p) => p.id == postId));
    emit(PostsListCubitPostHasBeenRemoved(
        posts: currentPosts,
        removedPost: removedPost,
        categoryId: getCategoryId()));
  }

  void updatePostBookmarkStatusWithoutChangingState(
      String postId, bool newBookmarkStatus) {
    if (state is PostsListCubitFetching) {
      (state as PostsListCubitFetching)
          .currentPosts
          .firstWhereOrNull((p) => p.id == postId)
          ?.isBookmarked = newBookmarkStatus;
      return;
    }
    if (state is PostsListCubitFetchedSuccessfully) {
      int postIndex = (state as PostsListCubitFetchedSuccessfully)
          .previousPosts
          .indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        (state as PostsListCubitFetchedSuccessfully)
            .previousPosts[postIndex]
            .isBookmarked = newBookmarkStatus;
        return;
      }
      postIndex = (state as PostsListCubitFetchedSuccessfully)
          .newDownloadedPosts
          .indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        (state as PostsListCubitFetchedSuccessfully)
            .newDownloadedPosts[postIndex]
            .isBookmarked = newBookmarkStatus;
        return;
      }

      return;
    }
    if (state is PostsListCubitFetchingHasError) {
      (state as PostsListCubitFetchingHasError)
          .currentPosts
          .firstWhereOrNull((p) => p.id == postId)
          ?.isBookmarked = newBookmarkStatus;
    }
  }

  List<Post> allPosts() {
    if (state is PostsListCubitFetching) {
      return (state as PostsListCubitFetching).currentPosts;
    }
    if (state is PostsListCubitFetchedSuccessfully) {
      return (state as PostsListCubitFetchedSuccessfully).previousPosts +
          (state as PostsListCubitFetchedSuccessfully).newDownloadedPosts;
    }
    if (state is PostsListCubitFetchingHasError) {
      return (state as PostsListCubitFetchingHasError).currentPosts;
    }
    if (state is PostsListCubitPostHasBeenAdded) {
      return (state as PostsListCubitPostHasBeenAdded).posts;
    }
    if (state is PostsListCubitPostHasBeenRemoved) {
      return (state as PostsListCubitPostHasBeenRemoved).posts;
    }

    return List.empty();
  }

  String? getCategoryId() {
    if (state is PostsListCubitFetching) {
      return (state as PostsListCubitFetching).categoryId;
    }
    if (state is PostsListCubitFetchedSuccessfully) {
      return (state as PostsListCubitFetchedSuccessfully).categoryId;
    }
    if (state is PostsListCubitFetchingHasError) {
      return (state as PostsListCubitFetchingHasError).categoryId;
    }
    if (state is PostsListCubitPostHasBeenAdded) {
      return (state as PostsListCubitPostHasBeenAdded).categoryId;
    }
    if (state is PostsListCubitPostHasBeenRemoved) {
      return (state as PostsListCubitPostHasBeenRemoved).categoryId;
    }
  }
}
