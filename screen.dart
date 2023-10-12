import 'package:flutter/material.dart';
import 'package:m03/dbHelper.dart';
import 'package:m03/itemScreen.dart';
import 'package:m03/MyProvider.dart';
import 'package:m03/screenHistoryPert3.dart';
import 'package:m03/ShoppingList.dart';
import 'package:m03/shoppingListDialog.dart';
import 'package:provider/provider.dart';

class ScreenPertemuan3 extends StatefulWidget {
  const ScreenPertemuan3({Key? key}) : super(key: key);

  @override
  State<ScreenPertemuan3> createState() => _ScreenPertemuan3State();
}

class _ScreenPertemuan3State extends State<ScreenPertemuan3> {
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getMyShoppingList().then((value) => tmp.setShoppingList = value);

    tmp.loadData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ScreenHistoryPertemuan3();
                },
              ));
            },
            icon: Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              _dbHelper.deleteAllShoppingList();
              tmp.deleteAll();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tmp.shoppingList != [] ? tmp.shoppingList.length : 0,
        itemBuilder: (context, index) {
          return Dismissible(
              key: Key(tmp.shoppingList[index].name),
              onDismissed: (direction) {
                String tmpName = tmp.shoppingList[index].name;
                int tmpId = tmp.shoppingList[index].id;
                setState(() {
                  tmp.deleteById(tmp.shoppingList[index]);
                });
                _dbHelper.deleteShoppingList(tmpId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$tmpName deleted"),
                  ),
                );
              },
              child: ListTile(
                title: Text(tmp.shoppingList[index].name),
                leading: CircleAvatar(
                  child: Text("${tmp.shoppingList[index].sum}"),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ItemScreen(tmp.shoppingList[index]);
                  }));
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ShoppingListDialog(_dbHelper).buildDialog(
                            context, tmp.shoppingList[index], false);
                      },
                    );
                    _dbHelper
                        .getMyShoppingList()
                        .then((value) => tmp.setShoppingList = value);
                  },
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return ShoppingListDialog(_dbHelper).buildDialog(
                  context, ShoppingList(tmp.savedId + 1, "", 0), true);
            },
          );
          _dbHelper
              .getMyShoppingList()
              .then((value) => tmp.setShoppingList = value);
        },
      ),
    );
  }

  @override
  void dispose() {
    _dbHelper.closeDB();
    super.dispose();
  }
}