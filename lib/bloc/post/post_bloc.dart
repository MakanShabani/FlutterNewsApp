// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/entities/entities.dart';
import '../../models/repositories/repositories.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<PostEvent>((event, emit) async {
      if (event is PostToggleBookmarkEvent) {
        emit(PostTogglingBookmarkState(postId: event.postId));

        ResponseModel<void> togglingResponse =
            await postRepository.toggleBookmark(postId: event.postId);

        if (togglingResponse.statusCode != 204) {
          emit(PostTogglingPostBookmarkHasErrorState(
            postId: event.postId,
            errorModel: togglingResponse.error!,
          ));
          return;
        }

        //everything is ok

        emit(PostTogglingPostBookmarkSuccessfullState(postId: event.postId));
      }
    });
  }
}
