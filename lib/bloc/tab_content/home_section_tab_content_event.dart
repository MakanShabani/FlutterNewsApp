part of 'home_section_tab_content_bloc.dart';

@immutable
abstract class HomeSectionTabContentEvent {}

class HomeSectionTabContentInitializeEvent extends HomeSectionTabContentEvent {
  final AuthenticatedUserModel? user;
  HomeSectionTabContentInitializeEvent({this.user});
}

class HomeSectionTabContentFetchMorePostsEvent
    extends HomeSectionTabContentEvent {
  final AuthenticatedUserModel? user;

  HomeSectionTabContentFetchMorePostsEvent({this.user});
}

class HomeSectionTabContentUpdatePostBookmarkEvent
    extends HomeSectionTabContentEvent {
  final String postId;
  final bool newBookmarkStatus;

  HomeSectionTabContentUpdatePostBookmarkEvent({
    required this.postId,
    required this.newBookmarkStatus,
  });
}
