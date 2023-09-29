import 'package:responsive_admin_dashboard/src/features/posts/domain/post.dart';

import '../../../../server_impementation/data_sources/search_data_source.dart';

import '../../../../infrastructure/shared_dtos/response_dto.dart';
import '../search_data.dart';

class FakeSearchRepository implements SearchRepository {
  FakeSearchRepository(
      {required this.delayDurationInSeconds, required this.searchDataSource});

  final int delayDurationInSeconds;
  final SearchDataSource searchDataSource;

  @override
  Future<ResponseDTO<SearchResultDto>> searchTitle(
      {required String text}) async {
    return await Future.delayed(
      Duration(seconds: delayDurationInSeconds),
      () {
        // do stuff here
        ResponseDTO<List<Post>> search =
            searchDataSource.searchViaTextInTitle(text: text);
        SearchResultDto searchResultDto = SearchResultDto(searchText: text);
        searchResultDto.posts = search.data;
        return ResponseDTO(
            statusCode: search.statusCode,
            data: searchResultDto,
            error: search.error);
      },
    );
  }
}
