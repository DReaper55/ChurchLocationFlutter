import 'dart:io';

import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/utils/user_db_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class SavedUserDB {
  SavedUserDB.privateConst();

  static final SavedUserDB instance = SavedUserDB.privateConst();

  static final String tableName = "users";
  static final String dbName = "users2.db";

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
        ${UserDBConstants.id} INTEGER PRIMARY KEY,
        ${UserDBConstants.state} TEXT NOT NULL,
        ${UserDBConstants.uid} TEXT NOT NULL,
        ${UserDBConstants.hobby} TEXT NOT NULL,
        ${UserDBConstants.country} TEXT NOT NULL,
        ${UserDBConstants.title} TEXT NOT NULL,
        ${UserDBConstants.church} TEXT NOT NULL,
        ${UserDBConstants.bioData} TEXT NOT NULL,
        ${UserDBConstants.doBaptism} TEXT NOT NULL,
        ${UserDBConstants.doBirth} TEXT NOT NULL,
        ${UserDBConstants.email} TEXT NOT NULL,
        ${UserDBConstants.fullName} TEXT NOT NULL,
        ${UserDBConstants.gender} TEXT NOT NULL,
        ${UserDBConstants.username} TEXT NOT NULL,
        ${UserDBConstants.emailVerified} TEXT NOT NULL,
        ${UserDBConstants.titleVerified} TEXT NOT NULL
        )
        ''');
      },
    );
  }

  Future<UserObject> insert(UserObject userObject) async {
    print("Demo: ${userObject.fullname}");
    Database db = await instance.database;

    userObject.dbId = await db.insert(tableName, userObject.toMap());
    // colId = int.parse(demoMod.uid);
    // print("Column Id: $colId");

    updateUser(userObject);

    return userObject;
  }

  Future<UserObject> getUser(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    List<Map> userObject = await db.query(tableName,
        columns: [
          UserDBConstants.id,
          UserDBConstants.state,
          UserDBConstants.email,
          UserDBConstants.uid,
          UserDBConstants.church,
          UserDBConstants.country,
          UserDBConstants.fullName,
          UserDBConstants.username,
          UserDBConstants.bioData,
          UserDBConstants.doBirth,
          UserDBConstants.doBaptism,
          UserDBConstants.hobby,
          UserDBConstants.gender,
          UserDBConstants.title,
          UserDBConstants.emailVerified,
          UserDBConstants.titleVerified
        ],
        where: '${UserDBConstants.id} = ?',
        whereArgs: [id]);

    return UserObject.fromMap(userObject.first);
  }

  Future<UserObject> getAllUsers() async {
    List<UserObject> listsOfUsers = [];
    Database db = await instance.database;
    List<Map> userObject = await db.query(tableName);

    /*List<Map> userMap = await db.query(tableName);
    userMap.forEach((element) {
      listsOfUsers.add(UserObject.fromMap(element));
    });

    print([listsOfUsers]);*/
    return UserObject.fromMap(userObject.first);
  }

  Future<int> updateUser(UserObject userObject) async {
    // int id = int.parse(demoMod.uid);
    Database db = await instance.database;
    userObject.dbId = 1;
    return await db.update(tableName, userObject.toMapDB(),
        where: '${UserDBConstants.id} = ?', whereArgs: [userObject.dbId]);
  }

  Future<int> deleteUser(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '${UserDBConstants.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteAllUsers() async {
    Database db = await instance.database;
    return await db.delete(tableName);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future close() async => await instance.close();
}
