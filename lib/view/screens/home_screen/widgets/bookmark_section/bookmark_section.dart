import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/blocs.dart';
import '../../../../../repositories/repo_fake_implementaion/fake_repositories.dart';
import '../../../../../router/route_names.dart';
import '../../../../view_constants.dart';
import '../../../../widgets/widgest.dart';

class BookmarkSection extends StatelessWidget {
  const BookmarkSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Bookmarks'),
          stretch: true,
          pinned: true,
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is LoggedIn) {
            //Show user's bookmarks
            return BlocProvider(
              create: (context) => BookmarkedPostsListCubit(
                  haowManyPostToFetchEachTime: 10,
                  postRepository: context.read<FakePostReposiory>())
                ..fetch(userToken: state.user.token),
              child: BlocBuilder<BookmarkedPostsListCubit,
                  BookmarkedPostsListState>(
                builder: (context, state) {
                  if (state is BookmarkedPostsListFetchingSuccessful) {
                    return PostsListSection(items: state.posts);
                  } else if (state is BookmarkedPostsListFetchingHasError) {
                    //we show error (bnner/snackbar) with list of previous fetched-posts
                    if (state.previousLoadedPosts != null) {
                      return PostsListSection(
                          items: state.previousLoadedPosts!);
                    }
                    //first fetching has ended with error. there is no posts has been fetched yet to display
                    //so we show error widget(in the center of page or as dialog)
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                          child: Text('First fetching has ended with error')),
                    );
                  } else if (state is BookmarkedPostsListFetching) {
                    if (state.previousLoadedPosts != null) {
                      //we show loading indicator at the end of the previously fetched-posts
                      return PostsListSection(
                          items: state.previousLoadedPosts!);
                    }
                    //this first fetching. there is no posts has been fetched yet to display
                    //so we show loading indicator widget(in the center of page or as dialog)
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('First fetching Loading')),
                    );
                  }

                  //Initial State
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child:
                        Center(child: Text('Initia State -- First Fetching')),
                  );
                },
              ),
            );
          } else {
            //Show warning widget that user must be signed in to use bookmark section

            return SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(0, 0, 0, screenBottomPadding),
                child: NotSigenIn(
                  onActionClicked: () =>
                      Navigator.pushNamed(context, loginRoute),
                ),
              ),
            );
          }
        }),
      ],
    );
  }
}
