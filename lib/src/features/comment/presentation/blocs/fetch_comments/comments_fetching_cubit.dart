// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../../infrastructure/shared_dtos/shared_dtos.dart';
import '../../../../../infrastructure/shared_models/shared_model.dart';
import '../../../application/comment_application.dart';
import '../../../domain/comment.dart';

part 'comments_fetching_state.dart';

class CommentsFetchingCubit extends Cubit<CommentsFetchingState> {
  CommentsFetchingCubit(
      {required this.postId,
      required CommentsFetchingService fetchCommentsService})
      : _fetchCommentsService = fetchCommentsService,
        super(CommentsFetchingInitialState(
            comments: List.empty(), postId: postId));

  final CommentsFetchingService _fetchCommentsService;
  final String postId;

  void fetchComments({required int howManyShouldFetch}) async {
    //set the limit for pagingOption if a new limit is provided

    //do nothing if another fetching is in progress
    if (state is CommentsFetchingFetchingState) {
      return;
    }

    //everything is Ok, we proceed with the fetching
    //set state to Fetching mode
    if (!isClosed) {
      emit(CommentsFetchingFetchingState(
          comments: state.comments, postId: postId));
    } else {
      //stream is Closed
      return;
    }

    // fetch the comments via FetchCommentsService and get the response from the server
    ResponseDTO<List<Comment>> responseDTO =
        await _fetchCommentsService.getComments(
            postId: postId,
            pagingOptionsDTO: PagingOptionsDTO(
                offset: state.comments.length, limit: howManyShouldFetch));

    //process the response
    if (responseDTO.statusCode == 200) {
      //we successfully fetched the new comments
      //emit a new state based on the length of the newly fetched comments and current comments

      if (responseDTO.data!.isEmpty) {
        //fetched comments == 0  --> if we also have no comments in our comments list, we emit a new empty state,
        //-otherwise emit a new No More Comments To Fetch state
        if (state.comments.isEmpty) {
          //fetched commnets length + current comments length == 0

          //check whether the bloc is closed
          if (!isClosed) {
            emit(CommentsFetchingListIsEmpty(
                comments: state.comments, postId: state.postId));
          }
          return;
        } else {
          //fetched commnets length(0) + current comments length(>0) > 0
          //means there is no more comments to fetch

          //check whether the bloc is closed
          if (!isClosed) {
            emit(CommentsFetchingNoMoreToFetch(
                comments: state.comments, postId: state.postId));
          }
          return;
        }
      } else {
        // we emit CommentsFetchedState

        //check whether the bloc is closed
        if (!isClosed) {
          emit(CommentsFetchingFetchedState(
              comments: state.comments + responseDTO.data!,
              postId: state.postId,
              fetchedComments: responseDTO.data!));
        }
        return;
      }
    } else {
      //we have error
      //emit new Error state if the stream(bloc) is not closed, otherwise we do nothing and terminate the whole process
      if (!isClosed) {
        emit(CommentsFetchingFailedState(
            postId: postId,
            comments: state.comments,
            error: responseDTO.error!));
      }
      return;
    }
  }
}
