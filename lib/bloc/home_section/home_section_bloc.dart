// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/repositories/repositories.dart';

part 'home_section_event.dart';
part 'home_section_state.dart';

class HomeSectionBloc extends Bloc<HomeSectionEvent, HomeSectionState> {
  final CategoryRepository categoryRepository;

  HomeSectionBloc({required this.categoryRepository})
      : super(HomeSectionInitial()) {
    on<HomeSectionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
