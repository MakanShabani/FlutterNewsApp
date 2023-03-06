part of 'post_details_cubit.dart';

@immutable
abstract class PostDetailsState {}

class PostDetailsInitial extends PostDetailsState {}

class PostDetailsFetching extends PostDetailsState {}

class PostDetailsFetchedSuccessfully extends PostDetailsState {
  PostDetailsFetchedSuccessfully({required this.post});
  final Post post;
}

class PostDetailsFetchingHasError extends PostDetailsState {
  PostDetailsFetchingHasError({required this.error});
  final ErrorModel error;
}
