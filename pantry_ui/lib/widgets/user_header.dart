import 'package:flutter/material.dart';
import 'package:pantry_ui/widgets/user_image.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var currentUser = appState.currentUser;
    var textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      UserImage(url: currentUser?.user.photoUrl),
      Text(style: textStyle, currentUser?.user.displayName == null ? "" : currentUser!.user.displayName!),
    ]);
  }
}
