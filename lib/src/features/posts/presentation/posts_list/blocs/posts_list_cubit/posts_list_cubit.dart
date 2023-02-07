// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../application/posts_services.dart';
import '../../../../domain/posts_models.dart';
import 'package:collection/collection.dart';
part 'posts_list_cubit_state.dart';

class PostsListCubit extends Cubit<PostsListCubitState> {
  PostsListCubit({
    required PostsListService postsListService,
    required this.haowManyPostFetchEachTime,
  })  : _postsListService = postsListService,
        assert(haowManyPostFetchEachTime >= 10),
        super(PostsListCubitInitial(posts: List.empty()));

  final PostsListService _postsListService;
  final int haowManyPostFetchEachTime;

  void fetch(String? userToken, String? categoryId,
      bool? loadOnlyBookmarkedPosts) async {
    if (state is PostsListCubitFetching) {
      return;
    }

    emit(PostsListCubitFetching(
      categoryId: categoryId,
      posts: state.posts,
    ));

    //load posts
    ResponseDTO<List<Post>> fetchingPostsResponse;

    //fetch only user bookmarked post or all posts
    if (loadOnlyBookmarkedPosts != null &&
        loadOnlyBookmarkedPosts &&
        userToken != null) {
      //fetch user bookmarked posts
      fetchingPostsResponse = await _postsListService.getUserBookmarkedPosts(
          userToken: userToken,
          pagingOptionsDTO: PagingOptionsDTO(
              offset: state.posts.length, limit: haowManyPostFetchEachTime));
    } else {
      //fetch all posts(including user bookmarked posts)
      fetchingPostsResponse = await _postsListService.getPosts(
          pagingOptionsDTO: PagingOptionsDTO(
              offset: state.posts.length, limit: haowManyPostFetchEachTime),
          userToken: userToken,
          categoryId: categoryId);
    }

    if (fetchingPostsResponse.statusCode != 200) {
      emit(PostsListCubitFetchingHasError(
          posts: state.posts,
          categoryId: categoryId,
          error: fetchingPostsResponse.error!));
      return;
    }

    emit(PostsListCubitFetchedSuccessfully(
      previousPostsLenght: state.posts.length,
      posts: state.posts + fetchingPostsResponse.data!,
      categoryId: categoryId,
    ));
  }

  void removePostFromList({required String postId}) {
    Post removedPost =
        state.posts.removeAt(state.posts.indexWhere((p) => p.id == postId));
    emit(PostsListCubitPostHasBeenRemoved(
        posts: state.posts,
        removedPost: removedPost,
        categoryId: state.categoryId));
  }

  void updatePostBookmarkStatusWithoutChangingState(
      Post post, bool newBookmarkStatus) {
    state.posts.firstWhereOrNull((p) => p.id == post.id)?.isBookmarked =
        newBookmarkStatus;
    return;
  }

  void addPostToTheList({required Post post}) {
    //add post to the first of the list
    //like we fetch posts from a server --> it returns the latest bookmarks first
    emit(PostsListCubitPostHasBeenAdded(
        posts: [post] + state.posts, addedPost: post));
  }

  void resetToInitial() {
    emit(PostsListCubitInitial(
        posts: List.empty(), categoryId: state.categoryId));
  }
}
