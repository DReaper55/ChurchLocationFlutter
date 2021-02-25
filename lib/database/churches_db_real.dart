import 'dart:io';

import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/utils/church_model_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class ChurchesDB {
  ChurchesDB.privateConst();

  static final ChurchesDB instance = ChurchesDB.privateConst();

  static final String tableName = "churches";
  static final String dbName = "church0.db";

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
    String path = join(documentsDirectory.path, dbName);

    return await open(path);
  }

  Future open(String path) async {
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName (
        ${ChurchDBConstants.id} INTEGER PRIMARY KEY,
        ${ChurchDBConstants.state} TEXT NOT NULL,
        ${ChurchDBConstants.churchName} TEXT NOT NULL,
        ${ChurchDBConstants.churchLat} TEXT NOT NULL,
        ${ChurchDBConstants.churchLng} TEXT NOT NULL,
        ${ChurchDBConstants.country} TEXT NOT NULL,
        ${ChurchDBConstants.address} TEXT NOT NULL,
        ${ChurchDBConstants.pastorName} TEXT NOT NULL,
        ${ChurchDBConstants.region} TEXT NOT NULL,
        ${ChurchDBConstants.about} TEXT NOT NULL,
        ${ChurchDBConstants.number} TEXT NOT NULL
        )
        ''');
      },
    );
  }

  Future<ChurchDistance> insert(ChurchDistance churchDistance) async {
    print("Demo: ${churchDistance.churchName}");
    Database db = await instance.database;
    // columnId = demoMod.uid;
    print(columnId);
    // demoMod.id = ;
    churchDistance.id = await db.insert(tableName, churchDistance.toJson());
    // colId = int.parse(demoMod.uid);
    // print("Column Id: $colId");

    updateChurch(churchDistance);

    return churchDistance;
  }

  Future<ChurchDistance> getChurch(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    List<Map> churchDistance = await db.query(tableName,
        columns: [
          ChurchDBConstants.id,
          ChurchDBConstants.state,
          ChurchDBConstants.churchName,
          ChurchDBConstants.churchLat,
          ChurchDBConstants.churchLng,
          ChurchDBConstants.country,
          ChurchDBConstants.address,
          ChurchDBConstants.pastorName,
          ChurchDBConstants.region,
          ChurchDBConstants.number
        ],
        where: '${ChurchDBConstants.id} = ?',
        whereArgs: [id]);

    return ChurchDistance.fromMap(churchDistance.first);
  }

  Future<List<ChurchDistance>> getAllChurches() async {
    List<ChurchDistance> listsOfDemos = [];
    Database db = await instance.database;
    List<Map> demoMap = await db.query(tableName);
    demoMap.forEach((element) {
      listsOfDemos.add(ChurchDistance.fromMap(element));
    });

    print([listsOfDemos]);
    return listsOfDemos;
  }

  Future<int> updateChurch(ChurchDistance churchDistance) async {
    // int id = int.parse(demoMod.uid);
    Database db = await instance.database;
    return await db.update(tableName, churchDistance.toMap(),
        where: '${ChurchDBConstants.id} = ?', whereArgs: [churchDistance.id]);
  }

  Future<int> deleteChurch(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    return await db.delete(tableName,
        where: '${ChurchDBConstants.id} = ?', whereArgs: [id]);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future close() async => await instance.close();
}
