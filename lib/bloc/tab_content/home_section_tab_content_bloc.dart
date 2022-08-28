// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import 'package:collection/collection.dart';

import '../../repositories/repositories.dart';

part 'home_section_tab_content_event.dart';
part 'home_section_tab_content_state.dart';

class HomeSectionTabContentBloc
    extends Bloc<HomeSectionTabContentEvent, HomeSectionTabContentState> {
  final PostRepository postRepository;
  final int haowManyPostToFetchEachTime;
  final String? categoryId;

  HomeSectionTabContentBloc({
    required this.postRepository,
    required this.haowManyPostToFetchEachTime,
    this.categoryId,
  }) : super(
          HomeSectionTabContentInitial(
            posts: List.empty(),
            pagingOptionsVm:
                PagingOptionsVm(offset: 0, limit: haowManyPostToFetchEachTime),
          ),
        ) {
    on<HomeSectionTabContentInitializeEvent>((event, emit) async {
      //Fetch Posts For The First Time
      emit(HomeSectionTabContentInitializingState(
          categoryId: categoryId,
          pagingOptionsVm: state.pagingOptionsVm,
          posts: state.posts));

      //get latest news
      ResponseModel<List<Post>> postsResponse = await postRepository.getPosts(
          categoryId: categoryId, pagingOptionsVm: state.pagingOptionsVm);

      if (postsResponse.statusCode != 200) {
        emit(HomeSectionTabContentInitializingHasErrorState(
          error: postsResponse.error!,
          categoryId: categoryId,
          posts: state.posts,
          pagingOptionsVm: state.pagingOptionsVm,
        ));
      }
      //everything is ok

      emit(HomeSectionTabContentInitializingSuccessfullState(
        categoryId: categoryId,
        posts: postsResponse.data!,
        pagingOptionsVm: state.pagingOptionsVm,
      ));
      return;
    });

    //Fetch More Post
    on<HomeSectionTabContentFetchMorePostsEvent>((event, emit) async {
      if (state is HomeSectionTabContentInitial ||
          state is HomeSectionTabContentInitializingState ||
          state is HomeSectionTabContentInitializingHasErrorState) {
        return;
      }

      emit(
        HomeSectionTabContentFetchingMorePostState(
          categoryId: categoryId,
          posts: state.posts,
          pagingOptionsVm: state.pagingOptionsVm,
          fetchingPagingOptionsVm: PagingOptionsVm(
            offset: state.posts.length,
            limit: haowManyPostToFetchEachTime,
          ),
        ),
      );

      ResponseModel<List<Post>> postResponse = await postRepository.getPosts(
          pagingOptionsVm: (state as HomeSectionTabContentFetchingMorePostState)
              .fetchingPagingOptionsVm,
          categoryId: state.categoryId);

      if (postResponse.statusCode != 200) {
        emit(HomeSectionTabContentFetchingMorePostHasErrorState(
          error: postResponse.error!,
          categoryId: state.categoryId,
          posts: state.posts,
          pagingOptionsVm: state.pagingOptionsVm,
          errorPagingOptionsVm:
              (state as HomeSectionTabContentFetchingMorePostState)
                  .fetchingPagingOptionsVm,
        ));
      }

      //everything is ok

      emit(HomeSectionTabContentFetchingMorePostSuccessfullState(
          categoryId: state.categoryId,
          posts: state.posts + postResponse.data!,
          pagingOptionsVm: (state as HomeSectionTabContentFetchingMorePostState)
              .fetchingPagingOptionsVm));

      return;
    });

    on<HomeSectionTabContentUpdatePostBookmarkEvent>((event, emit) async {
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
