import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common_widgets/common_widgest.dart';
import '../../../../infrastructure/constants.dart/constants.dart';
import '../../../../router/route_names.dart';
import '../../../authentication/domain/authentication_models.dart';
import '../../../authentication/presentation/authentication_presentations.dart';

class UserInfoSummarySection extends StatelessWidget {
  const UserInfoSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          screenHorizontalPadding, 20.0, screenHorizontalPadding, 0),
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        buildWhen: (previous, current) =>
            current is AuthenticationLoggedIn ||
            current is AuthenticationLoggedout ||
            current is AuthenticationLoggingIn ||
            current is AuthenticationLoggingOut ||
            current is AuthenticationLoggingInError,
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
                    child: state is AuthenticationLoggedIn ||
                            state is AuthenticationLoggingOut
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
                    state is AuthenticationLoggedIn ||
                            state is AuthenticationLoggingOut
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
                    state is AuthenticationLoggedIn ||
                            state is AuthenticationLoggingOut
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
                      onPressed: state is AuthenticationLoggedIn
                          ? () => onSignOutClick(context, state.user)
                          : () => onSignInClicked(context),
                      child: state is AuthenticationLoggingIn ||
                              state is AuthenticationLoggingOut
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                state is AuthenticationLoggingOut
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
                          : state is AuthenticationLoggedIn
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

  void onSignOutClick(BuildContext ct, User user) {
    ct.read<AuthenticationCubit>().logout(user: user);
  }
}
