import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/blocs.dart';

class InputSections extends StatelessWidget {
  const InputSections(
      {Key? key,
      required this.emailTextChanged,
      required this.passwordTextChanged})
      : super(key: key);

  final ValueSetter<String> emailTextChanged;
  final ValueSetter<String> passwordTextChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                enabled: state is! LoggingIn,
                onChanged: (val) => emailTextChanged(val),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  hintMaxLines: 1,
                  icon: Icon(
                    Icons.alternate_email_sharp,
                    size: 25.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                enabled: state is! LoggingIn,
                onChanged: (val) => passwordTextChanged(val),
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintMaxLines: 1,
                  icon: Icon(
                    Icons.lock_outline,
                    size: 25.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
