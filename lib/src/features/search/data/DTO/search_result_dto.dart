import '../../../posts/domain/posts_models.dart';

class SearchResultDto {
  final String searchText;
  List<Post>? posts;

  SearchResultDto({required this.searchText, this.posts});
}
