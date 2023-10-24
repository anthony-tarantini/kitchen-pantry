import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String? url;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
        width: 75.0,
        height: 75.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.primary, width: 5),
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(url == null ? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png" : url!)
            )
        )
    );
  }
}
