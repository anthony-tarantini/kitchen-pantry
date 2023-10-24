import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:pantry_ui/domain/user.dart';

class AppState extends ChangeNotifier {
  User? currentUser;
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void login(User user) {
    currentUser = user;
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
