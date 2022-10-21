import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../bloc/blocs.dart';
import '../../../../../widgets/widgest.dart';

class FirstBox extends StatelessWidget {
  const FirstBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            buildWhen: (previous, current) =>
                current is ThemeDarkModeState || current is ThemeLightModeState,
            builder: (context, state) {
              return SwitchListTile(
                value: state is ThemeDarkModeState,
                onChanged: (_) => context.read<ThemeCubit>().toggle(),
                title: const SwicthTitle(
                  text: 'Dark Mode',
                ),
              );
            },
          ),
          SwitchListTile(
            value: true,
            onChanged: (newValue) => {},
            title: const SwicthTitle(text: 'Notifications'),
          )
        ],
      ),
    );
  }
}
