import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/pantry_user.dart';
import 'networking/api_client.dart';

const clientId = "1007851537683-bl092bdpmkn89hmiflkm1nf47k39j8vm";
GoogleSignIn _googleSignIn = GoogleSignIn(clientId: clientId);

class AppState extends ChangeNotifier {
  ApiClient client = ApiClient();
  String accessToken = "";
  var current = WordPair.random();
  var history = <WordPair>[];
  PantryUser? currentUser;

  GlobalKey? historyListKey;

  void init() {
    SharedPreferences.getInstance().then((value) {
      var oldUser = value.getStringList("user_string_list");
      if (oldUser != null) {
        currentUser = PantryUser.fromStringList(oldUser);
      }
      if ((currentUser?.expiry ?? 0) < DateTime.now().millisecondsSinceEpoch) {
        _googleSignIn.signInSilently();
      }
    });

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      if (account != null) {
        login(account);
      }
    });
  }

  void login(GoogleSignInAccount user) async {
    var prefs = await SharedPreferences.getInstance();

    var authentication = (await user.authentication);
    accessToken = authentication.idToken!;
    var authenticationResponse = (await client.authenticate(accessToken));

    PantryUser currentUser = PantryUser(
        displayName: user.displayName,
        email: user.email,
        userImageUrl: user.photoUrl,
        accessToken: accessToken,
        userId: authenticationResponse.id,
        expiry: authenticationResponse.expiry);

    this.currentUser = currentUser;

    await prefs.setStringList("user_string_list", currentUser.toStringList());

    notifyListeners();
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    currentUser = null;
    _googleSignIn.signOut();

    await prefs.remove("user_string_list");

    notifyListeners();
  }

  bool isAuthorized() {
    return currentUser != null;
  }

  PantryUser? getUser() {
    return currentUser;
  }

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  Future<void> handleSignIn() async {
    try {
      _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}
