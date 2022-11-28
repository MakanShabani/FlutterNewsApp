import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common_widgets/common_widgest.dart';
import '../../../../settings/presentation/blocs/settings_blocs.dart';
import '../../blocs/authentication_cubit.dart';

class ButtonSections extends StatelessWidget {
  const ButtonSections({Key? key, required this.signInOnPressed})
      : super(key: key);
  final VoidCallback signInOnPressed;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: state is AuthenticationLoggingIn ? null : () => {},
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed:
                  state is AuthenticationLoggingIn ? null : signInOnPressed,
              child: state is AuthenticationLoggingIn
                  ? Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Signing in'),
                          SizedBox(
                            width: 2.0,
                          ),
                          LoadingIndicator(
                            hasBackground: false,
                            topPadding: 3.0,
                          )
                        ],
                      ),
                    )
                  : const Text('Sign in'),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: Colors.black12,
                    endIndent: 8.0,
                  ),
                ),
                Text(
                  'OR',
                ),
                Expanded(
                    child: Divider(
                  color: Colors.black12,
                  indent: 8.0,
                )),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            BlocBuilder<ThemeCubit, ThemeState>(
              buildWhen: (previous, current) =>
                  current is ThemeDarkModeState ||
                  current is ThemeLightModeState,
              builder: (context, state) {
                return SignInButton(
                  backgroundColor: state is ThemeDarkModeState
                      ? Colors.white
                      : Colors.black12,
                  logoImageAsset: 'assets/images/google.png',
                  text: 'Sign in with Google',
                  onPressed: state is AuthenticationLoggingIn ? null : () => {},
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New to Shaspeaker?',
                ),
                TextButton(
                  onPressed: state is AuthenticationLoggingIn ? null : () => {},
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
