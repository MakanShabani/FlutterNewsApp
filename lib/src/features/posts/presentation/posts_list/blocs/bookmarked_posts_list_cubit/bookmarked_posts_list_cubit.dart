// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../application/posts_services.dart';
import '../../../../domain/posts_models.dart';

part 'bookmarked_posts_list_state.dart';

class BookmarkedPostsListCubit extends Cubit<BookmarkedPostsListState> {
  BookmarkedPostsListCubit({
    required BookmarkedPostsListServcie bookmarkedPostsListService,
    required this.haowManyPostToFetchEachTime,
  })  : _bookmarkedPostsListService = bookmarkedPostsListService,
        assert(haowManyPostToFetchEachTime >= 10),
        super(BookmarkedPostsListInitial());

  final BookmarkedPostsListServcie _bookmarkedPostsListService;
  final int haowManyPostToFetchEachTime;

  void fetch({required String userToken}) async {
    List<Post>? currentPosts;
    PagingOptionsDTO? currentPagingOptionsDTO;
    PagingOptionsDTO toFetchPagingOptionsDTO;
    String? categoryId;

    if (state is BookmarkedPostsListFetchingHasError) {
      currentPosts =
          (state as BookmarkedPostsListFetchingHasError).previousLoadedPosts;
      currentPagingOptionsDTO = (state as BookmarkedPostsListFetchingHasError)
          .previousPagingOptionsDTO;
      categoryId = (state as BookmarkedPostsListFetchingHasError).categoryId;
    } else if (state is BookmarkedPostsListFetchingSuccessful) {
      if (state is BookmarkedPostsListFetchingSuccessful) {
        currentPosts = (state as BookmarkedPostsListFetchingSuccessful).posts;
        currentPagingOptionsDTO =
            (state as BookmarkedPostsListFetchingSuccessful)
                .currentPagingOptionsDTO;
        categoryId =
            (state as BookmarkedPostsListFetchingSuccessful).categoryId;
      }
    }

    //define pagingOptionsDTOPagingOptionsDTO to use in fetching
    if (currentPagingOptionsDTO != null) {
      //This fetching process is not the first one.
      toFetchPagingOptionsDTO = PagingOptionsDTO(
          offset:
              currentPagingOptionsDTO.offset + currentPagingOptionsDTO.limit,
          limit: haowManyPostToFetchEachTime);
    } else {
      //This fetching process is the first one to load.
      toFetchPagingOptionsDTO =
          PagingOptionsDTO(offset: 0, limit: haowManyPostToFetchEachTime);
    }

    emit(BookmarkedPostsListFetching(
      previousLoadedPosts: currentPosts,
      currentPagingOptionsDTO: currentPagingOptionsDTO,
      fetchingPagingOptionsDTO: toFetchPagingOptionsDTO,
      categoryId: categoryId,
    ));

    ResponseDTO<List<Post>> fetchingPostsResponse =
        await _bookmarkedPostsListService.getUserBookmarekdPosts(
      userToken: userToken,
      pagingOptionsDTO: toFetchPagingOptionsDTO,
    );

    if (fetchingPostsResponse.statusCode != 200) {
      emit(BookmarkedPostsListFetchingHasError(
          hadToLoadPagingOptionsDTO: toFetchPagingOptionsDTO,
          previousLoadedPosts: currentPosts,
          previousPagingOptionsDTO: currentPagingOptionsDTO,
          categoryId: categoryId,
          error: fetchingPostsResponse.error!));
      return;
    }

    emit(BookmarkedPostsListFetchingSuccessful(
      currentPagingOptionsDTO: toFetchPagingOptionsDTO,
      posts: fetchingPostsResponse.data!,
      categoryId: categoryId,
    ));
  }
}
