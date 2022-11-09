// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import 'package:collection/collection.dart';

import '../../repositories/repositories.dart';

part 'posts_list_event.dart';
part 'posts_list_state.dart';

class PostsListBloc extends Bloc<PostsListEvent, PostsListState> {
  final PostRepository postRepository;
  final int haowManyPostToFetchEachTime;
  final String? categoryId;

  PostsListBloc({
    required this.postRepository,
    required this.haowManyPostToFetchEachTime,
    this.categoryId,
  }) : super(
          PostsListInitial(
            posts: List.empty(),
            pagingOptionsVm:
                PagingOptionsVm(offset: 0, limit: haowManyPostToFetchEachTime),
          ),
        ) {
    on<PostsListInitializeEvent>((event, emit) async {
      //Fetch Posts For The First Time
      emit(PostsListInitializingState(
          categoryId: categoryId,
          pagingOptionsVm: state.pagingOptionsVm,
          posts: state.posts));

      //get latest news
      ResponseModel<List<Post>> postsResponse;
      if (event.user != null) {
        postsResponse = await postRepository.getPosts(
            userToken: event.user!.token,
            categoryId: categoryId,
            pagingOptionsVm: state.pagingOptionsVm);
      } else {
        postsResponse = await postRepository.getPostsAsguest(
            categoryId: categoryId, pagingOptionsVm: state.pagingOptionsVm);
      }
      if (postsResponse.statusCode != 200) {
        emit(PostsListInitializingHasErrorState(
          error: postsResponse.error!,
          categoryId: categoryId,
          posts: state.posts,
          pagingOptionsVm: state.pagingOptionsVm,
        ));
      }
      //everything is ok

      emit(PostsListInitializingSuccessfulState(
        categoryId: categoryId,
        posts: postsResponse.data!,
        pagingOptionsVm: state.pagingOptionsVm,
      ));
      return;
    });

    //Fetch More Post
    on<PostsListFetchMorePostsEvent>((event, emit) async {
      if (state is PostsListInitial ||
          state is PostsListInitializingState ||
          state is PostsListInitializingHasErrorState) {
        return;
      }

      emit(
        PostsListFetchingMorePostState(
          categoryId: categoryId,
          posts: state.posts,
          pagingOptionsVm: state.pagingOptionsVm,
          fetchingPagingOptionsVm: PagingOptionsVm(
            offset: state.posts.length,
            limit: haowManyPostToFetchEachTime,
          ),
        ),
      );
      ResponseModel<List<Post>> postResponse;

      if (event.user != null) {
        postResponse = await postRepository.getPosts(
            userToken: event.user!.token,
            pagingOptionsVm: (state as PostsListFetchingMorePostState)
                .fetchingPagingOptionsVm,
            categoryId: state.categoryId);
      } else {
        postResponse = await postRepository.getPostsAsguest(
            pagingOptionsVm: (state as PostsListFetchingMorePostState)
                .fetchingPagingOptionsVm,
            categoryId: state.categoryId);
      }

      if (postResponse.statusCode != 200) {
        emit(PostsListFetchingMorePostHasErrorState(
          error: postResponse.error!,
          categoryId: state.categoryId,
          posts: state.posts,
          pagingOptionsVm: state.pagingOptionsVm,
          errorPagingOptionsVm:
              (state as PostsListFetchingMorePostState).fetchingPagingOptionsVm,
        ));
      }

      //everything is ok

      emit(PostsListFetchingMorePostSuccessfulState(
          categoryId: state.categoryId,
          posts: state.posts + postResponse.data!,
          pagingOptionsVm: (state as PostsListFetchingMorePostState)
              .fetchingPagingOptionsVm));

      return;
    });

    on<PostsListUpdatePostBookmarkEvent>((event, emit) async {
      state.posts.firstWhereOrNull((p) => p.id == event.postId)?.isBookmarked =
          event.newBookmarkStatus;

      // int index = state.posts.indexWhere((p) => p.id == event.postId);

      // if (index == -1) return;

      // emit(HomeSectionTabContentPostBookmarkUpdated(
      //   posts: state.posts..[index].isBookmarked = event.newBookmarkStatus,
      //   pagingOptionsVm: state.pagingOptionsVm));
    });
  }
}
