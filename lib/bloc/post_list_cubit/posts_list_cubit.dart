// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../repositories/repositories.dart';

part 'posts_list_cubit_state.dart';

class PostsListCubit extends Cubit<PostsListCubitState> {
  PostsListCubit({
    required this.postRepository,
    required this.haowManyPostToFetchEachTime,
  })  : assert(haowManyPostToFetchEachTime >= 10),
        super(PostsListCubitInitial());

  final PostRepository postRepository;
  final int haowManyPostToFetchEachTime;

  void fetch(String? userToken, String? categoryId) async {
    List<Post>? currentPosts;
    PagingOptionsVm? lastFetchedPagingOptionsVm;
    PagingOptionsVm toFetchPagingOptionsVm;

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
      toFetchPagingOptionsVm = PagingOptionsVm(
          offset: lastFetchedPagingOptionsVm.offset +
              lastFetchedPagingOptionsVm.limit,
          limit: haowManyPostToFetchEachTime);
    } else {
      //This fetching process is the first one to load.
      toFetchPagingOptionsVm =
          PagingOptionsVm(offset: 0, limit: haowManyPostToFetchEachTime);
    }

    emit(PostsListCubitFetching(
      toLoadPagingOptionsVm: toFetchPagingOptionsVm,
      categoryId: categoryId,
      currentPosts: currentPosts,
      lastLoadedPagingOptionsVm: lastFetchedPagingOptionsVm,
    ));

    //Fetch Data As a guest or a registered user
    ResponseModel<List<Post>> fetchingPostsResponse;
    if (userToken == null) {
      fetchingPostsResponse = await postRepository.getPostsAsguest(
          pagingOptionsVm: toFetchPagingOptionsVm);
    } else {
      fetchingPostsResponse = await postRepository.getPosts(
          userToken: userToken, pagingOptionsVm: toFetchPagingOptionsVm);
    }

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
