import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/models/entities/authenticated_user_model.dart';

import '../../../../../../bloc/blocs.dart';
import '../../../../../../router/route_names.dart';
import '../../../../../view_constants.dart' as view_constants;
import '../../../../../widgets/widgest.dart';

class UserInfoSummarySection extends StatelessWidget {
  const UserInfoSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(view_constants.screenHorizontalPadding,
          20.0, view_constants.screenHorizontalPadding, 0),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) =>
            current is LoggedIn ||
            current is Loggedout ||
            current is LoggingIn ||
            current is LoggingOut ||
            current is LoggingInError,
        builder: (context, state) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
                  child: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: state is LoggedIn || state is LoggingOut
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://resize-elle.ladmedia.fr/rcrop/1024,1024/img/var/plain_site/storage/images/people/la-vie-des-people/news/brad-pitt-en-fauteuil-roulant-une-photo-inquiete-ses-fans-3924809/94792543-1-fre-FR/Brad-Pitt-en-fauteuil-roulant-une-photo-inquiete-ses-fans.jpg'),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              size: 50.0,
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  width: 50.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state is LoggedIn || state is LoggingOut
                        ? Text(
                            'Makan Shabani',
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        : Text(
                            'You are not signed in',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    state is LoggedIn || state is LoggingOut
                        ? Text(
                            'makan.shabani@gmail.com',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        : Text(
                            "Please sign in to use\nall of the app features",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      onPressed: state is LoggedIn
                          ? () => onSignOutClick(context, state.user)
                          : () => onSignInClicked(context),
                      child: state is LoggingIn || state is LoggingOut
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                state is LoggingOut
                                    ? const Text('Signing Out')
                                    : const Text('Signing In'),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                const LoadingIndicator(
                                  hasBackground: false,
                                  topPadding: 3.0,
                                )
                              ],
                            )
                          : state is LoggedIn
                              ? const Text('Sign Out')
                              : const Text('Sign In'),
                    ),
                  ],
                ),
              ]);
        },
      ),
    );
  }

  void onSignInClicked(BuildContext ct) {
    Navigator.pushNamed(ct, loginRoute);
  }

  void onSignOutClick(BuildContext ct, AuthenticatedUserModel user) {
    ct.read<AuthenticationBloc>().add(LogoutEvent(user: user));
  }
}
