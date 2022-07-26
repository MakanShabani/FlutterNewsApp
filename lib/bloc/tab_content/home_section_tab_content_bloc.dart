// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/entities/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../models/repositories/repositories.dart';

part 'home_section_tab_content_event.dart';
part 'home_section_tab_content_state.dart';

class HomeSectionTabContentBloc
    extends Bloc<HomeSectionTabContentEvent, HomeSectionTabContentState> {
  final PostRepository postRepository;

  HomeSectionTabContentBloc({required this.postRepository})
      : super(HomeSectionTabContentInitial()) {
    on<HomeSectionTabContentEvent>((event, emit) async {
      if (event is HomeSectionTabContentInitializeEvent) {
        emit(HomeSectionTabContentInitializingState(
            currentCategory: event.categoryToLoad));

        //get latest news
        ResponseModel<List<Post>> postsResponse = await postRepository.getPosts(
            categoryId: event.categoryToLoad?.id,
            pagingOptionsVm: event.pagingOptions);

        if (postsResponse.statusCode != 200) {
          emit(HomeSectionTabContentInitializingHasErrorState(
            error: postsResponse.error!,
            currentCategory: event.categoryToLoad,
          ));
          return;
        }

        //everything is ok

        emit(HomeSectionTabContentInitializingSuccessfullState(
          currentCategory: event.categoryToLoad,
          posts: postsResponse.data!,
          pagingOptionsVm: event.pagingOptions,
        ));
        return;
      }

      if (event is HomeSectionTabContentFetchMorePostsEvent) {
        if (state is HomeSectionTabContentInitializingSuccessfullState ||
            state is HomeSectionTabContentFetchingMorePostSuccessfullState) {
          emit(HomeSectionTabContentFetchingMorePostState(
              currentCategory: event.categoryToLoad,
              posts: state is HomeSectionTabContentInitializingSuccessfullState
                  ? (state as HomeSectionTabContentInitializingSuccessfullState)
                      .posts
                  : (state
                          as HomeSectionTabContentFetchingMorePostSuccessfullState)
                      .posts,
              currentPagingOptions: state
                      is HomeSectionTabContentInitializingSuccessfullState
                  ? (state as HomeSectionTabContentInitializingSuccessfullState)
                      .pagingOptionsVm
                  : (state
                          as HomeSectionTabContentFetchingMorePostSuccessfullState)
                      .pagingOptionsVm,
              fetchingPagingOptionsVm: event.pagingOptions));
        } else {
          //state is FetchingMorePostHasErrorState

          emit(HomeSectionTabContentFetchingMorePostState(
            currentCategory: event.categoryToLoad,
            posts: (state as HomeSectionTabContentFetchingMorePostHasErrorState)
                .posts,
            currentPagingOptions:
                (state as HomeSectionTabContentFetchingMorePostHasErrorState)
                    .currentPagingOptions,
            fetchingPagingOptionsVm: event.pagingOptions,
          ));
        }

        ResponseModel<List<Post>> postResponse = await postRepository.getPosts(
            pagingOptionsVm: event.pagingOptions,
            categoryId: event.categoryToLoad?.id);

        if (postResponse.statusCode != 200) {
          emit(HomeSectionTabContentFetchingMorePostHasErrorState(
            error: postResponse.error!,
            currentCategory: event.categoryToLoad,
            posts: (state as HomeSectionTabContentFetchingMorePostState).posts,
            currentPagingOptions:
                (state as HomeSectionTabContentFetchingMorePostState)
                    .currentPagingOptions,
            errorPagingOptionsVm: event.pagingOptions,
          ));
        }

        //everything is ok

        emit(HomeSectionTabContentFetchingMorePostSuccessfullState(
            currentCategory:
                (state as HomeSectionTabContentFetchingMorePostState)
                    .currentCategory,
            posts: (state as HomeSectionTabContentFetchingMorePostState).posts +
                postResponse.data!,
            pagingOptionsVm: event.pagingOptions));

        return;
      }

      if (event is HomeSectionTabContentUpdatePostBookmarkStatus) {
        //we just update the post bookmark status without changing the state
        state is HomeSectionTabContentInitializingSuccessfullState
            ? (state as HomeSectionTabContentInitializingSuccessfullState)
                .posts
                .firstWhere((p) => p.id == event.postId)
                .isBookmarked = event.isBookmarked
            : state is HomeSectionTabContentFetchingMorePostState
                ? (state as HomeSectionTabContentFetchingMorePostState)
                    .posts
                    .firstWhere((p) => p.id == event.postId)
                    .isBookmarked = event.isBookmarked
                : state is HomeSectionTabContentFetchingMorePostSuccessfullState
                    ? (state
                            as HomeSectionTabContentFetchingMorePostSuccessfullState)
                        .posts
                        .firstWhere((p) => p.id == event.postId)
                        .isBookmarked = event.isBookmarked
                    : state
                            is HomeSectionTabContentFetchingMorePostHasErrorState
                        ? (state
                                as HomeSectionTabContentFetchingMorePostHasErrorState)
                            .posts
                            .firstWhere((p) => p.id == event.postId)
                            .isBookmarked = event.isBookmarked
                        : null;
      }
    });
  }
}
