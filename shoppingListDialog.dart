import 'package:flutter/material.dart';
import 'package:m03/dbHelper.dart';
import 'package:m03/ShoppingList.dart';

class ShoppingListDialog {
  DBHelper _dbHelper;
  ShoppingListDialog(this._dbHelper);

  final txtName = TextEditingController();
  final txtSum = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    if (!isNew) {
      txtName.text = list.name;
      txtSum.text = list.sum.toString();
    } else {
      txtName.text = "";
      txtSum.text = "";
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Shopping List Name'),
            ),
            TextField(
              controller: txtSum,
              decoration: const InputDecoration(hintText: 'Sum'),
            ),
            ElevatedButton(
              onPressed: () {
                list.name = txtName.text != "" ? txtName.text : "Empty";
                list.sum = txtSum.text != "" ? int.parse(txtSum.text) : 0;
                _dbHelper.insertShoppingList(list, isNew);
                Navigator.pop(context);
              },
              child: const Text('Save Shopping List'),
            )
          ],
        ),
      ),
    );
  }
}