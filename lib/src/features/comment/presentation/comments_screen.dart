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

  @override
  void initState() {
    super.initState();
    _commentsFetchingCubit = CommentsFetchingCubit(
        postId: widget.postId,
        howManyToFetchEachTime: 20,
        fetchCommentsService: CommentsFetchingService(
            commentRepository: context.read<FakeCommentsRepository>()))
      ..fetchComments();
    _scrollController = ScrollController();
    //_scrollController.addListener(scrollListenrer);
  }

  @override
  void dispose() {
    //_scrollController.removeListener(scrollListenrer);
    _scrollController.dispose();
    super.dispose();
  }

  // void scrollListenrer() {
  //   if (_commentsFetchingCubit.state.comments.isEmpty) {
  //     return;
  //   }

  //   if (_scrollController.offset ==
  //       _scrollController.position.maxScrollExtent) {
  //     //fetch new posts
  //     _commentsFetchingCubit.fetchComments(howManyShouldFetch: 50);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ListNotifireCubit<Comment>()),
        BlocProvider(
          create: (context) => _commentsFetchingCubit,
        ),
        // BlocProvider(
        //   create: (context) => SendCommentCubit(
        //       sendCommentService: CommentSendingService(
        //           commentRepository: context.read<CommentRepository>())),
        // ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: const CustomScrollView(
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
    );
  }
}
