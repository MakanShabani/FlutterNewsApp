// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/entities/entities.dart';
import '../../repositories/repositories.dart';

part 'post_bookmark_state.dart';

class PostBookmarkCubit extends Cubit<PostBookmarkState> {
  PostBookmarkCubit({required this.postRepository})
      : super(PostBookmarkInitialState(currentBookmarkingPosts: List.empty()));

  final PostRepository postRepository;

  void toggleBookmark(
      {required AuthenticatedUserModel user,
      required String postId,
      required bool newBookmarkValue}) async {
    if (state.currentBookmarkingPosts.contains(postId)) return;

    emit(PostBookmarkUpdatingPostBookmarkState(
      postId: postId,
      currentBookmarkingPosts: state.currentBookmarkingPosts + [postId],
    ));

    ResponseModel<void> updateBookmarkResponse = await postRepository
        .toggleBookmark(userToken: user.token, postId: postId);

    if (updateBookmarkResponse.statusCode != 204) {
      // we have error in updating post's bookmark status

      emit(PostBookmarkUpdateHasErrorState(
        currentBookmarkingPosts: state.currentBookmarkingPosts..remove(postId),
        postId: postId,
        error: updateBookmarkResponse.error!,
      ));

      return;
    }

    emit(PostBookmarkUpdatedSuccessfullyState(
      currentBookmarkingPosts: state.currentBookmarkingPosts..remove(postId),
      postId: postId,
      newBookmarkValue: newBookmarkValue,
    ));
  }
}
