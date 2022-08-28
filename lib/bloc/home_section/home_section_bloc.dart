// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../repositories/category_repository.dart';

part 'home_section_event.dart';
part 'home_section_state.dart';

class HomeSectionBloc extends Bloc<HomeSectionEvent, HomeSectionState> {
  final CategoryRepository categoryRepository;
  HomeSectionBloc({
    required this.categoryRepository,
  }) : super(HomeSectionInitial()) {
    on<HomeSectionEvent>((event, emit) async {
      if (event is HomeSectionInitializeEvent) {
        emit(HomeSectionInitializingState());

        //Get categories
        ResponseModel<List<PostCategory>> categoriesResponse =
            await categoryRepository.getCategories(
                pagingOptionsVm: event.pagingOptionsVm);

        if (categoriesResponse.statusCode != 200) {
          emit(HomeSectionInitializationHasErrorState(
              error: categoriesResponse.error!));
          return;
        }

        //everything is ok

        emit(HomeSectionInitializationSuccessfullState(
          categories: categoriesResponse.data!,
          pagingOptionsVm: event.pagingOptionsVm,
        ));
        return;
      }
    });
  }
}
