import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/shared_dtos/response_dto.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/shared_models/error_model.dart';
import '../../../application/search_service.dart';
import '../../../data/DTO/search_result_dto.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchService searchService})
      : _searchService = searchService,
        super(SearchInitial());

  final SearchService _searchService;

  void performSearch({required String text}) async {
    emit(SearchSearching(serachText: text));

    ResponseDTO<SearchResultDto> searchResult =
        await _searchService.serachViaPartOfTitle(text: text);

    if (searchResult.statusCode != 200) {
      // we have error
      emit(SearchFailed(error: searchResult.error!, searchtext: text));
      return;
    }

    //everything is ok - search is done successfully
    emit(SearchSucceeded(searchResultDto: searchResult.data!));
  }
}
