import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authentication/pantry_user.dart';
import 'networking/api_client.dart';

class AppState extends ChangeNotifier {
  PantryUser? currentUser;
  String accessToken = "";
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  Future<void> login(GoogleSignInAccount user) async {
    var authentication = (await user.authentication);
    accessToken = authentication.idToken!;
    var userId = (await authenticate(accessToken)).id;
    currentUser = PantryUser(user: user, accessToken: accessToken, userId: userId);
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  bool isAuthorized() {
    return currentUser != null;
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
}
