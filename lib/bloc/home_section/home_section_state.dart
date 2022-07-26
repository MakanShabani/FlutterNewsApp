part of 'home_section_bloc.dart';

@immutable
abstract class HomeSectionState {}

class HomeSectionInitial extends HomeSectionState {}

class HomeSectionInitializingState extends HomeSectionState {}

class HomeSectionInitializationSuccessfullState extends HomeSectionState {
  final List<PostCategory> categories;
  final PagingOptionsVm pagingOptionsVm;

  HomeSectionInitializationSuccessfullState({
    required this.categories,
    required this.pagingOptionsVm,
  });
}

class HomeSectionInitializationHasErrorState extends HomeSectionState {
  final ErrorModel error;

  HomeSectionInitializationHasErrorState({
    required this.error,
  });
}
