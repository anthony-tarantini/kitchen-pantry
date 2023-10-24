import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantry_ui/sign_in/sign_in_button.dart';
import 'package:pantry_ui/widgets/user_image.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../domain/user.dart';

const clientId = "1007851537683-bl092bdpmkn89hmiflkm1nf47k39j8vm";

GoogleSignIn _googleSignIn = GoogleSignIn(clientId: clientId);

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

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      if (account != null) {
        User user = User(
            userName: account.displayName == null ? "" : account.displayName!,
            email: account.email,
            photoUrl: account.photoUrl == null ? "" : account.photoUrl!);
        appState.login(user);
      }
    });

    _googleSignIn.signInSilently();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(flex: 1,),
        Text(style: theme.textTheme.displaySmall, createText(appState.isAuthorized(), appState.currentUser?.userName)),
        Spacer(flex: 1),
        createImage(appState.currentUser?.photoUrl),
        Spacer(flex: 1),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              !appState.isAuthorized() ? buildSignInButton(onPressed: _handleSignIn) : logoutButton(appState),
            ],
          ),
        ),
      ],
    );
  }
}

String createText(bool isAuthed, String? name) {
  if (isAuthed) {
    return 'Welcome $name';
  }
  return 'You are not currently signed in.';
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

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}
