// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../infrastructure/shared_models/shared_model.dart';
import '../../application/post_category_service.dart';
import '../../domain/post_category_models.dart';

part 'post_category_state.dart';

class PostCategoryCubit extends Cubit<PostCategoryState> {
  PostCategoryCubit(
      {required PostCategoryService postCategoryService,
      required int homwManyFetchEachTime})
      : _postCategoryService = postCategoryService,
        _howManyFetchEachTime = homwManyFetchEachTime,
        assert(homwManyFetchEachTime >= 4),
        super(PostCategoryInitial());

  final PostCategoryService _postCategoryService;
  final int _howManyFetchEachTime;

  void fetch() async {
    if (state is PostCategoryFethcing) {
      return;
    }

    PagingOptionsDTO pagingOptionsDTO;

    if (state is PostCategoryFetchingHasError) {
      if ((state as PostCategoryFetchingHasError).preiviousLoadedCategories ==
          null) {
        //First fetch
        pagingOptionsDTO =
            PagingOptionsDTO(offset: 0, limit: _howManyFetchEachTime);
        emit(PostCategoryFethcing(
          loadingPagingOptions: pagingOptionsDTO,
        ));
      } else {
        pagingOptionsDTO = PagingOptionsDTO(
            offset: (state as PostCategoryFetchingHasError)
                .preiviousLoadedCategories!
                .length,
            limit: _howManyFetchEachTime);
      }
      emit(PostCategoryFethcing(
        loadingPagingOptions: pagingOptionsDTO,
        preiviousLoadedCategories:
            (state as PostCategoryFetchingHasError).preiviousLoadedCategories,
        previousLoadedPagingOptions:
            (state as PostCategoryFetchingHasError).previousLoadedPagingOptions,
      ));
    } else if (state is PostCategoryFetchedSuccessfully) {
      pagingOptionsDTO = PagingOptionsDTO(
          offset: (state as PostCategoryFetchedSuccessfully)
                  .newLoadedPagingOptionsDTO
                  .offset +
              (state as PostCategoryFetchedSuccessfully)
                  .newLoadedPagingOptionsDTO
                  .limit,
          limit: _howManyFetchEachTime);

      emit(PostCategoryFethcing(
        loadingPagingOptions: pagingOptionsDTO,
        preiviousLoadedCategories: (state as PostCategoryFetchedSuccessfully)
                .previousPostCategories ??
            List<PostCategory>.empty() +
                (state as PostCategoryFetchedSuccessfully).newPostCategories,
        previousLoadedPagingOptions: PagingOptionsDTO(
          offset: 0,
          limit: (state as PostCategoryFetchedSuccessfully)
                  .previousPostCategories
                  ?.length ??
              0 +
                  (state as PostCategoryFetchedSuccessfully)
                      .newPostCategories
                      .length,
        ),
      ));
    } else {
      //First fetch
      pagingOptionsDTO =
          PagingOptionsDTO(offset: 0, limit: _howManyFetchEachTime);
      emit(PostCategoryFethcing(
        loadingPagingOptions: pagingOptionsDTO,
      ));
    }

    ResponseDTO responseDTO = await _postCategoryService.getCategories(
        pagingOptionsDTO: (state as PostCategoryFethcing).loadingPagingOptions);

    if (responseDTO.statusCode != 200) {
      //Error
      emit(PostCategoryFetchingHasError(
          loadingHasErrorPagingOptions:
              (state as PostCategoryFethcing).loadingPagingOptions,
          preiviousLoadedCategories:
              (state as PostCategoryFethcing).preiviousLoadedCategories,
          previousLoadedPagingOptions:
              (state as PostCategoryFethcing).previousLoadedPagingOptions,
          error: responseDTO.error!));
      return;
    }

    //everything is ok

    emit(PostCategoryFetchedSuccessfully(
        newPostCategories: responseDTO.data!,
        newLoadedPagingOptionsDTO:
            (state as PostCategoryFethcing).loadingPagingOptions,
        previousLoadedPagingOptionsDTO:
            (state as PostCategoryFethcing).previousLoadedPagingOptions,
        previousPostCategories:
            (state as PostCategoryFethcing).preiviousLoadedCategories));
  }

  List<PostCategory> allDownloadedPostCategorieS(
      PostCategoryFetchedSuccessfully tempState) {
    return tempState.previousPostCategories ??
        List<PostCategory>.empty() + tempState.newPostCategories;
  }
}
