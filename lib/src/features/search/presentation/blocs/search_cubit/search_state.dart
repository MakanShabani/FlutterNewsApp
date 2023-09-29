part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchSearching extends SearchState {
  const SearchSearching({required this.serachText});
  final String serachText;
}

final class SearchFailed extends SearchState {
  const SearchFailed({required this.error, required this.searchtext});
  final ErrorModel error;
  final String searchtext;
}

final class SearchSucceeded extends SearchState {
  const SearchSucceeded({required this.searchResultDto});
  final SearchResultDto searchResultDto;
}
