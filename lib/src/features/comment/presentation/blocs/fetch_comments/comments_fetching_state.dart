part of 'comments_fetching_cubit.dart';

@immutable
abstract class CommentsFetchingState extends Equatable {
  const CommentsFetchingState({required this.postId, required this.comments});
  final String postId;
  final List<Comment> comments;
  @override
  List<Object> get props => [postId, comments];
}

class CommentsFetchingInitialState extends CommentsFetchingState {
  const CommentsFetchingInitialState(
      {required super.postId, required super.comments});
}

class CommentsFetchingFetchingState extends CommentsFetchingState {
  const CommentsFetchingFetchingState(
      {required super.postId, required super.comments});
}

class CommentsFetchingFetchedState extends CommentsFetchingState {
  const CommentsFetchingFetchedState(
      {required super.postId,
      required super.comments,
      required this.fetchedComments});
  final List<Comment> fetchedComments;
}

class CommentsFetchingFailedState extends CommentsFetchingState {
  const CommentsFetchingFailedState(
      {required super.postId, required super.comments, required this.error});
  final ErrorModel error;
}

class CommentsFetchingListIsEmpty extends CommentsFetchingState {
  const CommentsFetchingListIsEmpty({
    required super.comments,
    required super.postId,
  });
}

class CommentsFetchingNoMoreToFetch extends CommentsFetchingState {
  const CommentsFetchingNoMoreToFetch({
    required super.comments,
    required super.postId,
  });
}
