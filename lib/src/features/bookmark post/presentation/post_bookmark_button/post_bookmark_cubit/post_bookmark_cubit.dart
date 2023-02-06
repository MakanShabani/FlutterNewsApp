// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../posts/domain/posts_models.dart';
import '../../../application/bookmark_service.dart';
part 'post_bookmark_state.dart';

class PostBookmarkCubit extends Cubit<PostBookmarkState> {
  PostBookmarkCubit({required BookmarkService bookmarkService})
      : _bookmarkService = bookmarkService,
        super(PostBookmarkInitialState(currentBookmarkingPosts: List.empty()));

  final BookmarkService _bookmarkService;

  void toggleBookmark(
      {required String userToken,
      required Post post,
      required bool newBookmarkValueToSet}) async {
    if (state.currentBookmarkingPosts.contains(post.id)) return;

    emit(PostBookmarkUpdatingPostBookmarkState(
      post: post,
      currentBookmarkingPosts: state.currentBookmarkingPosts + [post.id],
    ));

    ResponseDTO<void> updateBookmarkResponse = await _bookmarkService
        .togglePostBookmarkSatus(userToken: userToken, postId: post.id);

    if (updateBookmarkResponse.statusCode != 204) {
      // we have error in updating post's bookmark status

      emit(PostBookmarkUpdateHasErrorState(
        currentBookmarkingPosts: state.currentBookmarkingPosts..remove(post.id),
        post: post,
        error: updateBookmarkResponse.error!,
      ));

      return;
    }

    emit(PostBookmarkUpdatedSuccessfullyState(
      currentBookmarkingPosts: state.currentBookmarkingPosts..remove(post.id),
      post: post,
      newBookmarkValue: newBookmarkValueToSet,
    ));
  }
}
