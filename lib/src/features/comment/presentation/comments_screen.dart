import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/src/infrastructure/constants.dart/constants.dart';

import '../../../common_widgets/common_widgest.dart';
import '../application/comment_application.dart';
import '../data/repositories/fake_comments_repository.dart';
import '../domain/comment.dart';
import 'blocs/cubits.dart';
import 'widgets/comment_widgets.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late ScrollController _scrollController;
  late CommentsFetchingCubit _commentsFetchingCubit;
  late ListNotifireCubit<Comment> _listNotifireCubit;

  @override
  void initState() {
    super.initState();
    _commentsFetchingCubit = CommentsFetchingCubit(
        postId: widget.postId,
        howManyToFetchEachTime: 20,
        fetchCommentsService: CommentsFetchingService(
            commentRepository: context.read<FakeCommentsRepository>()))
      ..fetchComments();
    _listNotifireCubit = ListNotifireCubit();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListenrer);
    _scrollController.dispose();
    _listNotifireCubit.close();
    _commentsFetchingCubit.close();
    super.dispose();
  }

  void scrollListenrer() {
    if (_commentsFetchingCubit.state.comments.isEmpty) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      //fetch new posts
      _commentsFetchingCubit.fetchComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _listNotifireCubit),
        BlocProvider.value(value: _commentsFetchingCubit),
        // BlocProvider(
        //   create: (context) => SendCommentCubit(
        //       sendCommentService: CommentSendingService(
        //           commentRepository: context.read<CommentRepository>())),
        // ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<CommentsFetchingCubit, CommentsFetchingState>(
                  listenWhen: (previous, current) =>
                      //listen to the cubit in the following situations::::
                      //1. want to fetch new comments and already have some comments in our list -->> show the list's loading indicatior
                      //2. just fetched some new comments && already have some comments in our list -->> Insert new items to the list
                      //3. current state is noMoreCommentsToFetch -->> hide the list's loading indicatior
                      //4. fetching ended with an error and we already have some comments in our list -->> hide the list's loading indicatior
                      // and show the error via snackbar to the user
                      (current is CommentsFetchingFetchingState &&
                          current.comments.isNotEmpty) ||
                      (current is CommentsFetchingFetchedState &&
                          previous.comments.isNotEmpty) ||
                      current is CommentsFetchingNoMoreToFetch ||
                      (current is CommentsFetchingFailedState &&
                          current.comments.isNotEmpty),
                  listener: (context, state) {
                    if (state is CommentsFetchingFetchingState) {
                      // notify the list widget to show the loading indicator at the end of the list
                      _listNotifireCubit.showLoading();
                      //smooth scroll to the loading indicator if we are at the end of the list
                      if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent) {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent + 50,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      }
                      return;
                    }
                    if (state is CommentsFetchingFetchedState) {
                      // notify the list widget to insert newly fetched comments to the list via ListNotifireCubit

                      _listNotifireCubit.insertItems(
                          state.fetchedComments, false);
                      return;
                    }
                    if (state is CommentsFetchingNoMoreToFetch) {
                      // notify the list widget to hide the loading indicator at the end of the list
                      _listNotifireCubit.resetState();
                      return;
                    }
                    if (state is CommentsFetchingFetchedState) {
                      // notify the list widget to hide the loading indicator at the end of the list
                      _listNotifireCubit.resetState();
                      //TODO: show the error to the user via snackbar
                      return;
                    }
                  })
            ],
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                //Appbar Section
                AppbarSection(title: 'Comments'),

                //Free Space Between Appbar & rest of the page
                SliverToBoxAdapter(
                  child: SizedBox(height: screenTopPadding),
                ),
                //Comments List Section
                CommentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
