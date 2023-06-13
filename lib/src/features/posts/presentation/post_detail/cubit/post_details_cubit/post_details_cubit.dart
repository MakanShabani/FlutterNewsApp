// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../../application/post_service.dart';
import '../../../../domain/posts_models.dart';

part 'post_details_state.dart';

class PostDetailsCubit extends Cubit<PostDetailsState> {
  PostDetailsCubit({required PostService postService})
      : _postService = postService,
        super(PostDetailsInitial());

  final PostService _postService;

  void fetchPostDetails({String? userToken, required String postId}) async {
    //we do nothing is another fetch is in process
    if (state is PostDetailsFetching) {
      return;
    }

    ResponseDTO<Post> response =
        await _postService.getPostDetails(userToken: userToken, postId: postId);

    if (response.statusCode != 200) {
      //we have error
      emit(PostDetailsFetchingHasError(error: response.error!));
      return;
    }

    //everything is ok
    emit(PostDetailsFetchedSuccessfully(post: response.data!));
    return;
  }

  void updateBookmarkValue(bool newBookmarkValue) {
    if (state is! PostDetailsFetchedSuccessfully &&
        state is! PostDetailsBookmarkHasUpdated) return;
    emit(PostDetailsBookmarkHasUpdated(
        post: state is PostDetailsFetchedSuccessfully
            ? ((state as PostDetailsFetchedSuccessfully).post
              ..isBookmarked = newBookmarkValue)
            : ((state as PostDetailsBookmarkHasUpdated).post
              ..isBookmarked = newBookmarkValue),
        newBookmarkvalue: newBookmarkValue));
  }
}
