part of 'home_section_tab_content_bloc.dart';

@immutable
abstract class HomeSectionTabContentState {
  final String? categoryId;
  final List<Post> posts;
  final PagingOptionsVm pagingOptionsVm;
  const HomeSectionTabContentState({
    this.categoryId,
    required this.posts,
    required this.pagingOptionsVm,
  });
}

class HomeSectionTabContentInitial extends HomeSectionTabContentState {
  const HomeSectionTabContentInitial({
    required super.posts,
    required super.pagingOptionsVm,
    super.categoryId,
  });
}

class HomeSectionTabContentInitializingState
    extends HomeSectionTabContentState {
  const HomeSectionTabContentInitializingState({
    super.categoryId,
    required super.pagingOptionsVm,
    required super.posts,
  });
}

class HomeSectionTabContentInitializingSuccessfullState
    extends HomeSectionTabContentState {
  const HomeSectionTabContentInitializingSuccessfullState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
  });
}

class HomeSectionTabContentInitializingHasErrorState
    extends HomeSectionTabContentState {
  final ErrorModel error;

  const HomeSectionTabContentInitializingHasErrorState({
    super.categoryId,
    required super.pagingOptionsVm,
    required super.posts,
    required this.error,
  });
}

class HomeSectionTabContentFetchingMorePostState
    extends HomeSectionTabContentState {
  final PagingOptionsVm fetchingPagingOptionsVm;

  const HomeSectionTabContentFetchingMorePostState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
    required this.fetchingPagingOptionsVm,
  });
}

class HomeSectionTabContentFetchingMorePostSuccessfullState
    extends HomeSectionTabContentState {
  const HomeSectionTabContentFetchingMorePostSuccessfullState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
  });
}

class HomeSectionTabContentFetchingMorePostHasErrorState
    extends HomeSectionTabContentState {
  final PagingOptionsVm errorPagingOptionsVm;
  final ErrorModel error;

  const HomeSectionTabContentFetchingMorePostHasErrorState({
    required this.error,
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
    required this.errorPagingOptionsVm,
  });
}

class HomeSectionTabContentPostBookmarkUpdated
    extends HomeSectionTabContentState {
  const HomeSectionTabContentPostBookmarkUpdated({
    required super.posts,
    required super.pagingOptionsVm,
    super.categoryId,
  });
}
