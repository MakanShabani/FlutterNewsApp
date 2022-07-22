// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/entities/ViewModels/view_models.dart';
import '../../models/entities/entities.dart';
import '../../models/repositories/repositories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc({
    required this.categoryRepository,
  }) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) async {
      if (event is InitializeCategoryEvent) {
        emit(CategoriesInitializingState());

        //Get categories
        ResponseModel<List<PostCategory>> categoriesResponse =
            await categoryRepository.getCategories(
                pagingOptionsVm: event.pagingOptionsVm);

        if (categoriesResponse.statusCode != 200) {
          emit(CategoriesInitializationHasErrorState(
              error: categoriesResponse.error!));
          return;
        }

        //everything is ok

        emit(CategoriesInitializationSuccessfullState(
          categories: categoriesResponse.data!,
          pagingOptionsVm: event.pagingOptionsVm,
        ));
        return;
      }

      if (event is FetchMoreCategoryEvent) {
        if (state is! CategoriesInitializationSuccessfullState &&
            state is! FetchMoreCategorySuccessfullState &&
            state is! FetchMoreCategoryHasErrorState) return;

        if (state is CategoriesInitializationSuccessfullState ||
            state is FetchMoreCategorySuccessfullState) {
          emit(FetchingMoreCategoryState(
              categories: state is CategoriesInitializationSuccessfullState
                  ? (state as CategoriesInitializationSuccessfullState)
                      .categories
                  : (state as FetchMoreCategorySuccessfullState).categories,
              currentPagingOptions:
                  state is CategoriesInitializationSuccessfullState
                      ? (state as CategoriesInitializationSuccessfullState)
                          .pagingOptionsVm
                      : (state as FetchMoreCategorySuccessfullState)
                          .pagingOptionsVm,
              fetchingPagingOptions: event.pagingOptionsVm));
        } else {
          //state is FetchMoreCategoryHasErrorState

          emit(FetchingMoreCategoryState(
              categories: (state as FetchMoreCategoryHasErrorState).categories,
              currentPagingOptions: (state as FetchMoreCategoryHasErrorState)
                  .currentPagingOptions,
              fetchingPagingOptions: event.pagingOptionsVm));
        }

        //Get more categories
        ResponseModel<List<PostCategory>> categoriesResponse =
            await categoryRepository.getCategories(
                pagingOptionsVm: event.pagingOptionsVm);

        if (categoriesResponse.statusCode != 200) {
          emit(FetchMoreCategoryHasErrorState(
            error: categoriesResponse.error!,
            categories: (state as FetchingMoreCategoryState).categories,
            currentPagingOptions:
                (state as FetchingMoreCategoryState).currentPagingOptions,
            errorPagingOptions: event.pagingOptionsVm,
          ));
          return;
        }

        //everything is ok

        emit(FetchMoreCategorySuccessfullState(
          categories: (state as FetchingMoreCategoryState).categories +
              categoriesResponse.data!,
          pagingOptionsVm: event.pagingOptionsVm,
        ));
        return;
      }
    });
  }
}
