import 'package:flutter/material.dart';
import 'package:m03/ShoppingList.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemScreen(this.shoppingList);

  @override
  _ItemScreenState createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  final ShoppingList shoppingList;
  _ItemScreenState(this.shoppingList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
    );
  }
}