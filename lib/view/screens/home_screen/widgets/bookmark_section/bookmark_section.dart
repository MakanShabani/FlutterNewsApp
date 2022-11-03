import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/blocs.dart';
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

            return SliverFixedExtentList(
                delegate: SliverChildListDelegate([]), itemExtent: 160);
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
