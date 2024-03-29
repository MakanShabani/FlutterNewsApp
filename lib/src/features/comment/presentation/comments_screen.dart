import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaspeaker_news_app/src/features/authentication/presentation/authentication_presentations.dart';
import 'package:shaspeaker_news_app/src/features/comment/data/dtos/dtos.dart';
import 'package:shaspeaker_news_app/src/infrastructure/constants.dart/constants.dart';
import 'package:shaspeaker_news_app/src/router/route_names.dart';

import '../../../common_widgets/common_widgest.dart';
import '../application/comment_application.dart';
import '../data/repositories/fake_comments_repository.dart';
import '../data/repositories/repositories.dart';
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
  late SendCommentCubit _sendCommentCubit;
  @override
  void initState() {
    super.initState();
    _commentsFetchingCubit = CommentsFetchingCubit(
        postId: widget.postId,
        howManyToFetchEachTime: 10,
        fetchCommentsService: CommentsFetchingService(
            commentRepository: context.read<FakeCommentsRepository>()))
      ..fetchComments();
    _sendCommentCubit = SendCommentCubit(
        sendCommentService: CommentSendingService(
            commentRepository: context.read<FakeCommentsRepository>()));
    _listNotifireCubit = ListNotifireCubit();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListenrer);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListenrer);
    _scrollController.dispose();
    _listNotifireCubit.close();
    _sendCommentCubit.close();
    _commentsFetchingCubit.close();
    super.dispose();
  }

  void scrollListenrer() {
    if (_commentsFetchingCubit.state.comments.isEmpty) {
      return;
    }

    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      //fetch new comments when user scrolls to the end of the list
      _commentsFetchingCubit.fetchComments();
    }
  }

  void _onItemsInsertedToList() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(_scrollController.offset + 50.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _onSendCommentTap(String userInput) {
    late String userToken;
    late String userId;

    //check whether user is signed in

    if (context.read<AuthenticationCubit>().state is! AuthenticationLoggedIn) {
      // user is not signed in -->> show snackbar to notify the client and do nothing

      ScaffoldMessenger.of(context).showSnackBar(
        appSnackBar(
          context: context,
          message: error401SnackBar,
          action: () => Navigator.pushNamed(context, loginRoute),
          actionLabel: 'Sign In',
          isFloating: true,
        ),
      );

      return;
    }

    //everything is ok

    userToken =
        (context.read<AuthenticationCubit>().state as AuthenticationLoggedIn)
            .user
            .token;
    userId =
        (context.read<AuthenticationCubit>().state as AuthenticationLoggedIn)
            .user
            .token;

    _sendCommentCubit.sendComment(
        userToken: userToken,
        userId: userId,
        sendCommentDTO:
            SendCommentDTO(postId: widget.postId, content: userInput));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _listNotifireCubit),
        BlocProvider.value(value: _commentsFetchingCubit),
        BlocProvider.value(value: _sendCommentCubit),
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
                    if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent) {
                      _scrollController.animateTo(
                          _scrollController.offset + 30.0,
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
                }),
            BlocListener<SendCommentCubit, SendCommentState>(
                listener: (context, state) {
              if (state is SendCommentSentState) {
                //comment sent successfully
                //show snackbar to notify user
                ScaffoldMessenger.of(context).showSnackBar(
                  appSnackBar(
                    context: context,
                    message: commentsSentSuccessfullySnackBar,
                    action: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    actionLabel: 'OK',
                  ),
                );
                return;
              }
            }),
          ],
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    //Appbar Section
                    const AppbarSection(title: 'Comments'),
                    //Free Space between the appbar and rest of the page
                    const SliverToBoxAdapter(
                      child: SizedBox(height: screenTopPadding),
                    ),
                    //Comments List Section
                    CommentsSection(
                        onNewItemsAreInserted: _onItemsInsertedToList),
                  ],
                ),
              ),
              WritingSection(
                hintText: commentWritingSectionHint,
                onSendTap: (userInput) => _onSendCommentTap(userInput),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
