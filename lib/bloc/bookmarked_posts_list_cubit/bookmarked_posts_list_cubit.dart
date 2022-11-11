// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../repositories/repositories.dart';

part 'bookmarked_posts_list_state.dart';

class BookmarkedPostsListCubit extends Cubit<BookmarkedPostsListState> {
  BookmarkedPostsListCubit({
    required this.postRepository,
    required this.haowManyPostToFetchEachTime,
  })  : assert(haowManyPostToFetchEachTime >= 10),
        super(BookmarkedPostsListInitial());

  final PostRepository postRepository;
  final int haowManyPostToFetchEachTime;

  void fetch({required String userToken}) async {
    List<Post>? currentPosts;
    PagingOptionsVm? currentPagingOptionsVm;
    PagingOptionsVm toFetchPagingOptionsVm;
    String? categoryId;

    if (state is BookmarkedPostsListFetchingHasError) {
      currentPosts =
          (state as BookmarkedPostsListFetchingHasError).previousLoadedPosts;
      currentPagingOptionsVm = (state as BookmarkedPostsListFetchingHasError)
          .previousPagingOptionsVM;
      categoryId = (state as BookmarkedPostsListFetchingHasError).categoryId;
    } else if (state is BookmarkedPostsListFetchingSuccessful) {
      if (state is BookmarkedPostsListFetchingSuccessful) {
        currentPosts = (state as BookmarkedPostsListFetchingSuccessful).posts;
        currentPagingOptionsVm =
            (state as BookmarkedPostsListFetchingSuccessful)
                .currentPagingOptionsVM;
        categoryId =
            (state as BookmarkedPostsListFetchingSuccessful).categoryId;
      }
    }

    //define pagingOptionsVm to use in fetching
    if (currentPagingOptionsVm != null) {
      //This fetching process is not the first one.
      toFetchPagingOptionsVm = PagingOptionsVm(
          offset: currentPagingOptionsVm.offset + currentPagingOptionsVm.limit,
          limit: haowManyPostToFetchEachTime);
    } else {
      //This fetching process is the first one to load.
      toFetchPagingOptionsVm =
          PagingOptionsVm(offset: 0, limit: haowManyPostToFetchEachTime);
    }

    emit(BookmarkedPostsListFetching(
      previousLoadedPosts: currentPosts,
      currentPagingOptionsVM: currentPagingOptionsVm,
      fetchingPagingOptionsVM: toFetchPagingOptionsVm,
      categoryId: categoryId,
    ));

    ResponseModel<List<Post>> fetchingPostsResponse =
        await postRepository.getBookmarkedPosts(
            userToken: userToken, pagingOptionsVm: toFetchPagingOptionsVm);

    if (fetchingPostsResponse.statusCode != 200) {
      emit(BookmarkedPostsListFetchingHasError(
          hadToLoadPagingOptionsVM: toFetchPagingOptionsVm,
          previousLoadedPosts: currentPosts,
          previousPagingOptionsVM: currentPagingOptionsVm,
          categoryId: categoryId,
          error: fetchingPostsResponse.error!));
      return;
    }

    emit(BookmarkedPostsListFetchingSuccessful(
      currentPagingOptionsVM: toFetchPagingOptionsVm,
      posts: fetchingPostsResponse.data!,
      categoryId: categoryId,
    ));
  }
}
