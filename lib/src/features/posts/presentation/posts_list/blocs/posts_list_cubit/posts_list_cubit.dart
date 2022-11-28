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

  void fetch(String? userToken, String? categoryId) async {
    List<Post>? currentPosts;
    PagingOptionsDTO? lastFetchedPagingOptionsVm;
    PagingOptionsDTO toFetchPagingOptionsVm;

    if (state is PostsListCubitFetching) {
      return;
    }

    if (state is PostsListCubitFetchedSuccessfully) {
      currentPosts = allPostsFetchedSuccessfully(
          state as PostsListCubitFetchedSuccessfully);
      lastFetchedPagingOptionsVm = (state as PostsListCubitFetchedSuccessfully)
          .lastLoadedPagingOptionsVm;
      categoryId = categoryId;
    } else if (state is PostsListCubitFetchingHasError) {
      currentPosts = (state as PostsListCubitFetchingHasError).currentPosts;
      lastFetchedPagingOptionsVm =
          (state as PostsListCubitFetchingHasError).lastLoadedPagingOptionsVm;
      categoryId = categoryId;
    }

    //define pagingOptionsVm to use in fetching
    if (lastFetchedPagingOptionsVm != null) {
      //This fetching process is not the first one.
      toFetchPagingOptionsVm = PagingOptionsDTO(
          offset: lastFetchedPagingOptionsVm.offset +
              lastFetchedPagingOptionsVm.limit,
          limit: haowManyPostFetchEachTime);
    } else {
      //This fetching process is the first one to load.
      toFetchPagingOptionsVm =
          PagingOptionsDTO(offset: 0, limit: haowManyPostFetchEachTime);
    }

    emit(PostsListCubitFetching(
      toLoadPagingOptionsVm: toFetchPagingOptionsVm,
      categoryId: categoryId,
      currentPosts: currentPosts,
      lastLoadedPagingOptionsVm: lastFetchedPagingOptionsVm,
    ));

    //load posts
    ResponseDTO<List<Post>> fetchingPostsResponse =
        await _postsListService.getPosts(
            pagingOptionsDTO: toFetchPagingOptionsVm,
            userToken: userToken,
            categoryId: categoryId);

    if (fetchingPostsResponse.statusCode != 200) {
      emit(PostsListCubitFetchingHasError(
          toLoadPagingOptionsVm: toFetchPagingOptionsVm,
          lastLoadedPagingOptionsVm: lastFetchedPagingOptionsVm,
          currentPosts: currentPosts,
          categoryId: categoryId,
          error: fetchingPostsResponse.error!));
      return;
    }

    emit(PostsListCubitFetchedSuccessfully(
      lastLoadedPagingOptionsVm: toFetchPagingOptionsVm,
      previousPosts: currentPosts,
      newDownloadedPosts: fetchingPostsResponse.data!,
      categoryId: categoryId,
    ));
  }

  void updatePostBookmarkStatusWithoutChangingState(
      String postId, bool newBookmarkStatus) {
    if (state is PostsListCubitFetching) {
      (state as PostsListCubitFetching)
          .currentPosts
          ?.firstWhereOrNull((p) => p.id == postId)
          ?.isBookmarked = newBookmarkStatus;
    } else if (state is PostsListCubitFetchedSuccessfully) {
      allPostsFetchedSuccessfully(state as PostsListCubitFetchedSuccessfully)
          .firstWhereOrNull((p) => p.id == postId)
          ?.isBookmarked = newBookmarkStatus;
    } else if (state is PostsListCubitFetchingHasError) {
      (state as PostsListCubitFetchingHasError)
          .currentPosts
          ?.firstWhereOrNull((p) => p.id == postId)
          ?.isBookmarked = newBookmarkStatus;
    }
  }

  List<Post> allPostsFetchedSuccessfully(
      PostsListCubitFetchedSuccessfully state) {
    return state.previousPosts == null
        ? state.newDownloadedPosts
        : state.previousPosts! + state.newDownloadedPosts;
  }
}
