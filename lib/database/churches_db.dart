import 'dart:io';

import 'package:flutter_church_location/models/demo_mod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DemoDatabase {
  DemoDatabase.privateConst();

  static final DemoDatabase instance = DemoDatabase.privateConst();

  static final String demoTable = "demoTable";

  static String columnId = "id";
  static final String columnUid = "uid";
  static final String columnImageUrl = "imageUrl";
  static final String columnUserName = "userName";

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demon4.db");

    return await open(path);
  }

  Future open(String path) async {
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $demoTable (
        $columnId INTEGER PRIMARY KEY,
        $columnUid TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL,
        $columnUserName TEXT NOT NULL
        )
        ''');
      },
    );
  }

  Future<DemoMod> insert(DemoMod demoMod) async {
    print("Demo: ${demoMod.imageUrl}");
    Database db = await instance.database;
    // columnId = demoMod.uid;
    print(columnId);
    // demoMod.id = ;
    demoMod.id = await db.insert(demoTable, demoMod.toJson());
    // colId = int.parse(demoMod.uid);
    // print("Column Id: $colId");

    updateDemo(demoMod);

    return demoMod;
  }

  Future<DemoMod> getDemoMod(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    List<Map> demoMap = await db.query(demoTable,
        columns: [columnId, columnUid, columnImageUrl, columnUserName],
        where: '$columnId = ?',
        whereArgs: [id]);

    return DemoMod.fromMap(demoMap.first);
  }

  Future<List<DemoMod>> getAllDemos() async {
    List<DemoMod> listsOfDemos = [];
    Database db = await instance.database;
    List<Map> demoMap = await db.query(demoTable);
    demoMap.forEach((element) {
      listsOfDemos.add(DemoMod.fromMap(element));
    });

    print([listsOfDemos]);
    return listsOfDemos;
  }

  Future<int> updateDemo(DemoMod demoMod) async {
    // int id = int.parse(demoMod.uid);
    Database db = await instance.database;
    return await db.update(demoTable, demoMod.toMap(),
        where: '$columnId = ?', whereArgs: [demoMod.id]);
  }

  Future<int> deleteDemo(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    return await db.delete(demoTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $demoTable'));
  }

  Future close() async => await instance.close();
}
