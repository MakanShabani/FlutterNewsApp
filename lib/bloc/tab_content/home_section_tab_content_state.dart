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

//This state simplifies the state checking in the ui
//other states must be extend this state when they must show the main content instead of extending HomeSectionTabContentState.
//this state extends HomeSectionTabContentState.
//so in the ui when you want to check if main content of the page should be shown instead of checking each state type and then
//decide to show the main content or not we could only check if the state is of this type or not.
//instead of 'if(state is ... || if state is ...) => showMainCOntent()'
//we could use 'if(state is HomeSectionTabContentContentMustBeShownState) => showMainCOntent()'
abstract class HomeSectionTabContentContentMustBeShownState
    extends HomeSectionTabContentState {
  const HomeSectionTabContentContentMustBeShownState({
    required super.posts,
    required super.pagingOptionsVm,
    super.categoryId,
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
    extends HomeSectionTabContentContentMustBeShownState {
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
    extends HomeSectionTabContentContentMustBeShownState {
  final PagingOptionsVm fetchingPagingOptionsVm;

  const HomeSectionTabContentFetchingMorePostState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
    required this.fetchingPagingOptionsVm,
  });
}

class HomeSectionTabContentFetchingMorePostSuccessfullState
    extends HomeSectionTabContentContentMustBeShownState {
  const HomeSectionTabContentFetchingMorePostSuccessfullState({
    super.categoryId,
    required super.posts,
    required super.pagingOptionsVm,
  });
}

class HomeSectionTabContentFetchingMorePostHasErrorState
    extends HomeSectionTabContentContentMustBeShownState {
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
    extends HomeSectionTabContentContentMustBeShownState {
  const HomeSectionTabContentPostBookmarkUpdated({
    required super.posts,
    required super.pagingOptionsVm,
    super.categoryId,
  });
}
