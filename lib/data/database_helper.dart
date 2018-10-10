import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:allinone/models/detail.dart';
import 'package:allinone/models/final.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    print("Trying to open database");
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    print("Database opened");
    await db.execute(
        "CREATE TABLE User(id VARCHAR(400) PRIMARY KEY, token VARCHAR(400), email VARCHAR(400), password VARCHAR(400), active INTEGER)");
    print("Created tables");
  }

  Future<int> saveUser(Final _final) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", _final.toMap());
    print("Trying to save user");
    return res;
  }

  Future<int> deleteUser() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    print("Trying to delete user");
    return res;
  }

  Future<Detail> getDetailOfActiveUser() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM User WHERE active = 1');
    if (res.length > 0) {
      print("Trying to get details");
      return new Detail.fromMap(res.first);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true : false;
  }
}
