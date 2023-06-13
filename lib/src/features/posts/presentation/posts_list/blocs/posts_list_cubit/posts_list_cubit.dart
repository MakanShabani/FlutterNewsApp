// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../application/post_service.dart';
import '../../../../domain/posts_models.dart';
part 'posts_list_cubit_state.dart';

class PostsListCubit extends Cubit<PostsListCubitState> {
  PostsListCubit({
    required PostService postsListService,
    required this.haowManyPostFetchEachTime,
  })  : _postsListService = postsListService,
        assert(haowManyPostFetchEachTime >= 10),
        super(PostsListCubitInitial(posts: List.empty()));

  final PostService _postsListService;
  final int haowManyPostFetchEachTime;

  void fetch(String? userToken, String? categoryId,
      bool? loadOnlyBookmarkedPosts) async {
    if (state is PostsListCubitFetching) {
      return;
    }
    if (!isClosed) {
      emit(PostsListCubitFetching(
        categoryId: categoryId,
        posts: state.posts,
      ));
    }

    //load posts
    ResponseDTO<List<Post>> fetchingPostsResponse;

    //decide to fetch only user's bookmarks or all posts
    if (loadOnlyBookmarkedPosts != null && loadOnlyBookmarkedPosts) {
      //fetch user bookmarked posts
      fetchingPostsResponse = await _postsListService.getUserBookmarkedPosts(
          userToken: userToken ?? 'invalid_token',
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
      if (!isClosed) {
        emit(PostsListCubitFetchingHasError(
            posts: state.posts,
            categoryId: categoryId,
            error: fetchingPostsResponse.error!));
      }
      return;
    }

    //request is successfully ended7
    //check it was the first fetch or not, then, switch to proper state
    if ((state.posts + fetchingPostsResponse.data!).isEmpty) {
      //empty bookmarks
      if (!isClosed) {
        emit(PostsListCubitIsEmpty(
          posts: List.empty(),
          categoryId: state.categoryId,
        ));
      }
    } else {
      //User's Bookmarks List is not empty
      //Add fetched posts

      if (fetchingPostsResponse.data!.isEmpty) {
        //no more posts to fecth
        if (!isClosed) {
          emit(PostsListNoMorePostsToFetch(
            posts: state.posts,
            categoryId: state.categoryId,
          ));
        }
        return;
      } else {
        if (!isClosed) {
          emit(PostsListCubitFetchedSuccessfully(
            fetchedPosts: fetchingPostsResponse.data!,
            posts: state.posts + fetchingPostsResponse.data!,
            categoryId: categoryId,
          ));
        }
      }
    }
  }

  void removePostFromList({required String postId}) {
    Post removedPost =
        state.posts.removeAt(state.posts.indexWhere((p) => p.id == postId));
    if (state.posts.isEmpty) {
      //first notify a post has been removed
      if (!isClosed) {
        emit(PostsListCubitPostHasBeenRemoved(
            posts: state.posts,
            removedPost: removedPost,
            categoryId: state.categoryId));
      }
      //then notify post is empty
      if (!isClosed) {
        emit(PostsListCubitIsEmpty(
          posts: state.posts,
          categoryId: state.categoryId,
        ));
      }
    } else {
      //list is not empty
      if (!isClosed) {
        emit(PostsListCubitPostHasBeenRemoved(
            posts: state.posts,
            removedPost: removedPost,
            categoryId: state.categoryId));
      }
    }
  }

  void addPostToTheList({required Post post}) {
    //If the state is PostListCubitFetching - we do nothing
    if (state is PostsListCubitFetching) {
      return;
    }

    if (!isClosed) {
      emit(PostsListCubitPostHasBeenAdded(
        categoryId: state.categoryId,
        posts: [post] + state.posts, //add post to the first of the list
        addedPosts: [post],
      ));
    }
  }

  void emptyList() {
    if (!isClosed) {
      emit(PostsListCubitIsEmpty(
          posts: List.empty(), categoryId: state.categoryId));
    }
  }

  void updatePostsBookmarkStatus(
      {required String postId, required bool newBookmarkStatus}) {
    int index = state.posts.indexWhere((element) => element.id == postId);

    if (index == -1) {
      //item not found -->> not expected--> do nothing

      return;
    }

    //update the item's bookmark value but emit the same state
    if (!isClosed) {
      emit(state..posts[index].isBookmarked = newBookmarkStatus);
    }
  }
}
