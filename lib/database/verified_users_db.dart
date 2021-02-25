import 'dart:io';

import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/models/verified_user.dart';
import 'package:flutter_church_location/utils/user_db_constants.dart';
import 'package:flutter_church_location/utils/verified_users_db_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class VerifiedUsersDB {
  VerifiedUsersDB.privateConst();

  static final VerifiedUsersDB instance = VerifiedUsersDB.privateConst();

  static final String tableName = "verified_users";
  static final String dbName = "v_users.db";

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
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
        ${VerifiedUsersConstant.id} INTEGER PRIMARY KEY,
        ${VerifiedUsersConstant.uid} TEXT NOT NULL,
        ${VerifiedUsersConstant.fullName} TEXT NOT NULL,
        ${VerifiedUsersConstant.displayPic} TEXT NOT NULL,
        ${VerifiedUsersConstant.username} TEXT NOT NULL
        )
        ''');
      },
    );
  }

  Future<VerifiedUser> insert(VerifiedUser userObject) async {
    Database db = await instance.database;

    userObject.id = await db.insert(tableName, userObject.toMap());
    updateUser(userObject);

    return userObject;
  }

  Future<VerifiedUser> getUser(int id) async {
    Database db = await instance.database;
    List<Map> userObject = await db.query(tableName,
        columns: [
          VerifiedUsersConstant.id,
          VerifiedUsersConstant.uid,
          VerifiedUsersConstant.fullName,
          VerifiedUsersConstant.username
        ],
        where: '${VerifiedUsersConstant.id} = ?',
        whereArgs: [id]);

    return VerifiedUser.fromMap(userObject.first);
  }

  Future<List<VerifiedUser>> getAllUsers() async {
    Database db = await instance.database;
    List<VerifiedUser> listsOfUsers = [];

    List<Map> userMap = await db.query(tableName);
    userMap.forEach((element) {
      listsOfUsers.add(VerifiedUser.fromMap(element));
    });

    print([listsOfUsers]);
    return listsOfUsers;
  }

  Future<int> updateUser(VerifiedUser userObject) async {
    Database db = await instance.database;
    return await db.update(tableName, userObject.toMapDB(),
        where: '${VerifiedUsersConstant.id} = ?', whereArgs: [userObject.id]);
  }

  Future<int> deleteUser(int id) async {
    // int id = int.parse(uid);
    Database db = await instance.database;
    return await db.delete(tableName,
        where: '${VerifiedUsersConstant.id} = ?', whereArgs: [id]);
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
