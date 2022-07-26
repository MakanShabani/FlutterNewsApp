part of 'home_section_tab_content_bloc.dart';

@immutable
abstract class HomeSectionTabContentState {}

class HomeSectionTabContentInitial extends HomeSectionTabContentState {}

class HomeSectionTabContentInitializingState
    extends HomeSectionTabContentState {
  final PostCategory? currentCategory;

  HomeSectionTabContentInitializingState({
    this.currentCategory,
  });
}

class HomeSectionTabContentInitializingSuccessfullState
    extends HomeSectionTabContentState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm pagingOptionsVm;

  HomeSectionTabContentInitializingSuccessfullState({
    this.currentCategory,
    required this.posts,
    required this.pagingOptionsVm,
  });
}

class HomeSectionTabContentInitializingHasErrorState
    extends HomeSectionTabContentState {
  final PostCategory? currentCategory;
  final ErrorModel error;

  HomeSectionTabContentInitializingHasErrorState({
    this.currentCategory,
    required this.error,
  });
}

class HomeSectionTabContentFetchingMorePostState
    extends HomeSectionTabContentState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm currentPagingOptions;
  final PagingOptionsVm fetchingPagingOptionsVm;

  HomeSectionTabContentFetchingMorePostState({
    this.currentCategory,
    required this.posts,
    required this.currentPagingOptions,
    required this.fetchingPagingOptionsVm,
  });
}

class HomeSectionTabContentFetchingMorePostSuccessfullState
    extends HomeSectionTabContentState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm pagingOptionsVm;

  HomeSectionTabContentFetchingMorePostSuccessfullState({
    this.currentCategory,
    required this.posts,
    required this.pagingOptionsVm,
  });
}

class HomeSectionTabContentFetchingMorePostHasErrorState
    extends HomeSectionTabContentState {
  final PostCategory? currentCategory;
  final List<Post> posts;
  final PagingOptionsVm currentPagingOptions;
  final PagingOptionsVm errorPagingOptionsVm;
  final ErrorModel error;

  HomeSectionTabContentFetchingMorePostHasErrorState({
    required this.error,
    this.currentCategory,
    required this.posts,
    required this.currentPagingOptions,
    required this.errorPagingOptionsVm,
  });
}
