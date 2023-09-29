import 'package:responsive_admin_dashboard/src/infrastructure/shared_dtos/shared_dtos.dart';

import '../data/search_data.dart';

class SearchService {
  SearchService({required SearchRepository searchRepository})
      : _searchRepository = searchRepository;
  final SearchRepository _searchRepository;

  Future<ResponseDTO<SearchResultDto>> serachViaPartOfTitle(
      {required String text}) async {
    return await _searchRepository.searchTitle(text: text);
  }
}
