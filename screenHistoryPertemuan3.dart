import 'package:flutter/material.dart';
import 'package:m03/dbHelper.dart';
import 'package:m03/MyProvider.dart';
import 'package:provider/provider.dart';

class ScreenHistoryPertemuan3 extends StatefulWidget {
  const ScreenHistoryPertemuan3({Key? key}) : super(key: key);

  @override
  State<ScreenHistoryPertemuan3> createState() =>
      _ScreenHistoryPertemuan3State();
}

class _ScreenHistoryPertemuan3State extends State<ScreenHistoryPertemuan3> {
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getMyHistoryList().then((value) => tmp.sethistoryList = value);

    return Scaffold(
      appBar: AppBar(
        title: Text('History Changes'),
      ),
      body: ListView.builder(
        itemCount: tmp.historyList != [] ? tmp.historyList.length : 0,
        itemBuilder: (context, index) {
          return Stack(children: [
            Positioned(
              top: 5,
              right: 0,
              child: Text(
                tmp.historyList[index].date.toString(),
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: ListTile(
                leading: (tmp.historyList[index].type == "INSERT")
                    ? Icon(
                        Icons.edit,
                        color: Colors.green,
                      )
                    : (tmp.historyList[index].type == "UPDATE")
                        ? Icon(
                            Icons.update_rounded,
                            color: Colors.greenAccent,
                          )
                        : (tmp.historyList[index].type == "DELETE")
                            ? Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              )
                            : Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                title: Text(tmp.historyList[index].type),
                subtitle: Text(tmp.historyList[index].comment),
              ),
            ),
          ]);
        },
      ),
    );
  }
}