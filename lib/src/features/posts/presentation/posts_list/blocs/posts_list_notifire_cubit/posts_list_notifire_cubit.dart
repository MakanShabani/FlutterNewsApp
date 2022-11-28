// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../domain/posts_models.dart';

part 'posts_list_notifire_cubit_state.dart';

class PostsListNotifireCubit extends Cubit<PostsListNotifireCubitState> {
  PostsListNotifireCubit() : super(PostsListNotifireCubitInitial());

  void insertPosts(List<Post> posts) {
    if (posts.isEmpty) return;
    emit(PostsListNotifireCubitInsertPosts(posts: posts));
  }

  void removePost(String postId) {
    emit(PostsListNotifireCubitRemovePost(postId: postId));
  }
}
