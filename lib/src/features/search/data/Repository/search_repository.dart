import 'package:responsive_admin_dashboard/src/features/search/data/DTO/search_result_dto.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/shared_dtos/shared_dtos.dart';

abstract class SearchRepository {
  Future<ResponseDTO<SearchResultDto>> searchTitle({required String text});
}
