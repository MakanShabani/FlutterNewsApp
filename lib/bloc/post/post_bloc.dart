// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/entities/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../models/repositories/repositories.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(TabPageContentInitial()) {
    on<PostEvent>((event, emit) async {
      if (event is InitializePostsEvent) {
        emit(PostsInitializingState(currentCategory: event.categoryToLoad));

        //get latest news
        ResponseModel<List<Post>> postsResponse = await postRepository.getPosts(
            categoryId: event.categoryToLoad?.id,
            pagingOptionsVm: event.pagingOptions);

        if (postsResponse.statusCode != 200) {
          emit(PostsInitializingHasErrorState(
            error: postsResponse.error!,
            currentCategory: event.categoryToLoad,
          ));
          return;
        }

        //everything is ok

        emit(PostsInitializingSuccessfullState(
          currentCategory: event.categoryToLoad,
          posts: postsResponse.data!,
          pagingOptionsVm: event.pagingOptions,
        ));
        return;
      }

      if (event is FetchMorePostsEvent) {
        if (state is PostsInitializingSuccessfullState ||
            state is FetchingMorePostSuccessfullState) {
          emit(FetchingMorePostState(
              currentCategory: event.categoryToLoad,
              posts: state is PostsInitializingSuccessfullState
                  ? (state as PostsInitializingSuccessfullState).posts
                  : (state as FetchingMorePostSuccessfullState).posts,
              currentPagingOptions: state is PostsInitializingSuccessfullState
                  ? (state as PostsInitializingSuccessfullState).pagingOptionsVm
                  : (state as FetchingMorePostSuccessfullState).pagingOptionsVm,
              fetchingPagingOptionsVm: event.pagingOptions));
        } else {
          //state is FetchingMorePostHasErrorState

          emit(FetchingMorePostState(
            currentCategory: event.categoryToLoad,
            posts: (state as FetchingMorePostHasErrorState).posts,
            currentPagingOptions:
                (state as FetchingMorePostHasErrorState).currentPagingOptions,
            fetchingPagingOptionsVm: event.pagingOptions,
          ));
        }

        ResponseModel<List<Post>> postResponse = await postRepository.getPosts(
            pagingOptionsVm: event.pagingOptions,
            categoryId: event.categoryToLoad?.id);

        if (postResponse.statusCode != 200) {
          emit(FetchingMorePostHasErrorState(
            error: postResponse.error!,
            currentCategory: event.categoryToLoad,
            posts: (state as FetchingMorePostState).posts,
            currentPagingOptions:
                (state as FetchingMorePostState).currentPagingOptions,
            errorPagingOptionsVm: event.pagingOptions,
          ));
        }

        //everything is ok

        emit(FetchingMorePostSuccessfullState(
            currentCategory: (state as FetchingMorePostState).currentCategory,
            posts: (state as FetchingMorePostState).posts + postResponse.data!,
            pagingOptionsVm: event.pagingOptions));

        return;
      }
    });
  }
}
