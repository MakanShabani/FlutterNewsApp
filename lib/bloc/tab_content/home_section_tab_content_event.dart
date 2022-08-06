part of 'home_section_tab_content_bloc.dart';

@immutable
abstract class HomeSectionTabContentEvent {}

class HomeSectionTabContentInitializeEvent extends HomeSectionTabContentEvent {}

class HomeSectionTabContentFetchMorePostsEvent
    extends HomeSectionTabContentEvent {}

class HomeSectionTabContentUpdatePostBookmarkEvent
    extends HomeSectionTabContentEvent {
  final String postId;
  final bool newBookmarkStatus;

  HomeSectionTabContentUpdatePostBookmarkEvent({
    required this.postId,
    required this.newBookmarkStatus,
  });
}
