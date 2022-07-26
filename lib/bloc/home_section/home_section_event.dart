part of 'home_section_bloc.dart';

@immutable
abstract class HomeSectionEvent {}

class HomeSectionInitializeEvent extends HomeSectionEvent {
  final PagingOptionsVm pagingOptionsVm;

  HomeSectionInitializeEvent({
    required this.pagingOptionsVm,
  });
}
