import 'package:m03/listHistory.dart';
import 'package:m03/ShoppingList.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late SharedPreferences prefs;
  final _keyId = '_keyId';
  Database? _database;
  Database? _databaseHistory;
  final String _table_name = "shopping_list";
  final String _table_name_history = "history_list";
  final String _db_name = "shopping_list";
  final String _db_name_history = "history_list";
  final int _db_version = 1;
  final int _db_version_history = 1;

  DBHelper() {
    _openDB();
  }

  Future<void> _openDB() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _db_name),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_table_name (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)",
        );
      },
      version: _db_version,
    );
    _databaseHistory ??= await openDatabase(
      join(await getDatabasesPath(), _db_name_history),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_table_name_history (type TEXT, comment TEXT, date DATETIME PRIMARY KEY)",
        );
      },
      version: _db_version_history,
    );
  }

  Future<void> insertShoppingList(ShoppingList tmp, bool isNew) async {
    prefs = await SharedPreferences.getInstance();
    await _database?.insert(
      _table_name,
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    prefs.setInt(_keyId, tmp.id);
    await _databaseHistory?.insert(
      _table_name_history,
      {
        'type': (isNew) ? "INSERT" : "UPDATE",
        'comment': "Inserted Data : ${tmp.toString()}",
        'date': DateTime.now().toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  Future<List<ShoppingList>> getMyShoppingList() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query(_table_name);
      print("Isi DB" + maps.toString());
      return List.generate(maps.length, (i) {
        return ShoppingList(maps[i]['id'], maps[i]['name'], maps[i]['sum']);
      });
    }
    return [];
  }

  Future<List<ListHistory>> getMyHistoryList() async {
    if (_databaseHistory != null) {
      final List<Map<String, dynamic>> his_maps =
          await _databaseHistory!.query(_table_name_history);
      return List.generate(his_maps.length, (i) {
        return ListHistory(
          his_maps[i]['type'],
          his_maps[i]['comment'],
          DateTime.parse(his_maps[i]['date']),
        );
      });
    }
    return [];
  }

  Future<void> deleteShoppingList(int id) async {
    await _database?.delete(
      _table_name,
      where: 'id = ?',
      whereArgs: [id],
    );
    await _databaseHistory?.insert(
        _table_name_history,
        {
          'type': "DELETE",
          'comment': "Deleted Data with id : $id",
          'date': DateTime.now().toString(),
        },
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<void> deleteAllShoppingList() async {
    prefs = await SharedPreferences.getInstance();
    await _database?.delete(
      _table_name,
    );
    await _databaseHistory?.insert(_table_name_history, {
      'type': "RESET",
      'comment': "DELETED ALL DATA",
      'date': DateTime.now().toString(),
    });
    prefs.setInt(_keyId, 0);
  }

  Future<void> closeDB() async {
    await _database?.close();
  }
}