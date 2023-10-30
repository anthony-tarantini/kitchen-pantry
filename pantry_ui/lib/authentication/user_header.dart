import 'package:flutter/material.dart';
import 'package:pantry_ui/authentication/user_image.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  late AppState appState;

  @override
  Widget build(BuildContext context) {
    appState = context.watch<AppState>();

    var textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      UserImage(url: appState.getUser()?.userImageUrl),
      Text(style: textStyle, appState.getUser()?.displayName == null ? "" : appState.getUser()!.displayName!),
    ]);
  }
}
