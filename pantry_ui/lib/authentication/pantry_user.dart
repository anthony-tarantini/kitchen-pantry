import 'package:google_sign_in/google_sign_in.dart';

class PantryUser {
  GoogleSignInAccount user;
  String accessToken;
  int userId;

  PantryUser({required this.user, required this.accessToken, required this.userId});
}
