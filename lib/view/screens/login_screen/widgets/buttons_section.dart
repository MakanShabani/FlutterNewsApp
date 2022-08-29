import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../bloc/blocs.dart';
import '../../../widgets/widgest.dart';

class ButtonSections extends StatelessWidget {
  const ButtonSections({Key? key, required this.signInOnPressed})
      : super(key: key);
  final VoidCallback signInOnPressed;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: state is LoggingIn ? null : () => {},
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: state is LoggingIn ? null : signInOnPressed,
              child: state is LoggingIn
                  ? Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Signing in'),
                          SizedBox(
                            width: 2.0,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                            child: SpinKitThreeBounce(
                              size: 12.0,
                              color: Colors.black26,
                            ),
                          ),
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
                  style: TextStyle(color: Colors.black54),
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
            SignInButton(
              minimumHeight: 45.0,
              backgroundColor: Colors.black12,
              textColor: Colors.black54,
              borderRadious: 10.0,
              logoImageAsset: 'assets/images/google.png',
              text: 'Sign in with Google',
              onPressed: state is LoggingIn ? null : () => {},
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'New to Shaspeaker?',
                  style: TextStyle(color: Colors.black54),
                ),
                TextButton(
                  onPressed: state is LoggingIn ? null : () => {},
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
