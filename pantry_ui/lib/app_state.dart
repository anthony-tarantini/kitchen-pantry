import 'dart:collection';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'networking/api_client.dart';

class PantryUser {
  GoogleSignInAccount user;
  String accessToken;
  int userId;

  PantryUser({required this.user, required this.accessToken, required this.userId}){}
}

class AppState extends ChangeNotifier {
  PantryUser? currentUser;
  String accessToken = "";
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  Future<void> login(GoogleSignInAccount user) async {
    var authentication = (await user.authentication);
    accessToken = authentication.idToken!;
    var response = (await authenticate(accessToken));
    currentUser = PantryUser(user: user, accessToken: accessToken, userId: response.userId);
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
