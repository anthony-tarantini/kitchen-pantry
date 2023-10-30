import 'package:flutter/material.dart';
import 'package:pantry_ui/authentication/sign_in_button.dart';
import 'package:pantry_ui/authentication/user_image.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AppState appState;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(flex: 1,),
        Text(style: theme.textTheme.displaySmall, createText(appState.getUser()?.displayName)),
        Spacer(flex: 1),
        createImage(appState.getUser()?.userImageUrl),
        Spacer(flex: 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              !appState.isAuthorized() ? buildSignInButton(onPressed: appState.handleSignIn) : logoutButton(appState),
            ],
          ),
        ),
      ],
    );
  }
}

String createText(String? name) {
  return name != null ? 'Welcome $name' : 'You are not currently signed in.';
}

Widget createImage(String? url) {
  if (url == null) {
    return Placeholder(
      fallbackWidth: 190,
      fallbackHeight: 190,
    );
  } else {
    return UserImage(url: url);
  }
}

Widget logoutButton(AppState appState) {
  return ElevatedButton.icon(
    onPressed: () {
      appState.logout();
    },
    icon: Icon(Icons.logout),
    label: Text('Logout'),
  );
}
