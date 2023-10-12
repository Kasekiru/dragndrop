import 'package:flutter/material.dart';
import 'package:m03/listHistory.dart';
import 'package:m03/ShoppingList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListProductProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  int _savedId = 0;
  int get savedId => _savedId;
  set savedId(value) {
    _savedId = value;
    notifyListeners();
  }

  final _keyId = '_keyId';

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    _savedId = prefs.getInt(_keyId) ?? 0;
  }

  List<ShoppingList> _shoppingList = [];
  List<ShoppingList> get shoppingList => _shoppingList;
  set setShoppingList(value) {
    _shoppingList = value;
    notifyListeners();
  }

  List<ListHistory> _historyList = [];
  List<ListHistory> get historyList => _historyList;
  set sethistoryList(value) {
    _historyList = value.reversed.toList();
    notifyListeners();
  }

  void deleteById(shoppingList) {
    _shoppingList.remove(shoppingList);
    notifyListeners();
  }

  void deleteAll() async {
    prefs = await SharedPreferences.getInstance();
    _shoppingList = [];
    prefs.setInt(_keyId, 0);
    notifyListeners();
  }
}