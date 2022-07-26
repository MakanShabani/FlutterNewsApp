part of 'home_section_tab_content_bloc.dart';

@immutable
abstract class HomeSectionTabContentEvent {}

class HomeSectionTabContentInitializeEvent extends HomeSectionTabContentEvent {
  final PostCategory? categoryToLoad;
  final PagingOptionsVm pagingOptions;

  HomeSectionTabContentInitializeEvent({
    this.categoryToLoad,
    required this.pagingOptions,
  });
}

class HomeSectionTabContentFetchMorePostsEvent
    extends HomeSectionTabContentEvent {
  final PostCategory? categoryToLoad;
  final PagingOptionsVm pagingOptions;

  HomeSectionTabContentFetchMorePostsEvent({
    required this.categoryToLoad,
    required this.pagingOptions,
  });
}

class HomeSectionTabContentUpdatePostBookmarkStatus
    extends HomeSectionTabContentEvent {
  final String postId;
  final bool isBookmarked;

  HomeSectionTabContentUpdatePostBookmarkStatus({
    required this.postId,
    required this.isBookmarked,
  });
}
