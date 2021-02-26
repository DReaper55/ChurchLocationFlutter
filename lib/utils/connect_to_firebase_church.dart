import 'dart:async';

import 'package:firebase_core/firebase_core.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_church_location/database/churches_db.dart';
import 'package:flutter_church_location/database/churches_db_real.dart';
import 'package:flutter_church_location/models/church_distance.dart';

import 'package:flutter_church_location/models/demo_mod.dart';

class ConnectToFirebaseChurch {
  ChurchesDB churchesDB = ChurchesDB.instance;

  Future<ChurchesDB> getChurches() async {
    fb.Firebase.initializeApp();

    // FirebaseDatabase.instance
    //     .reference()
    //     .child('churches')
    //     .push()
    //     .set({'uid': 'random', 'imageUrl': 'image/url', 'userName': 'whyMe'});

    FirebaseDatabase.instance
        .reference()
        .child('churches')
        .onChildAdded
        .listen((event) async {
      Map<dynamic, dynamic> stuff = event.snapshot.value;
      List<ChurchDistance> lists = await churchesDB.getAllChurches();

      _performCheck(stuff, lists);

      int count = await churchesDB.queryRowCount();
      print("DATABASE COUNT: $count");
    });

    FirebaseDatabase.instance
        .reference()
        .child('churches')
        .onChildChanged
        .listen((event) async {
      Map<dynamic, dynamic> value = event.snapshot.value;

      List<ChurchDistance> lists = await churchesDB.getAllChurches();

      ChurchDistance churchDistance;
      churchDistance = ChurchDistance.fromJson(value);

      for (var i = 0; i < lists.length; i++) {
        if (lists[i].churchName == churchDistance.churchName) {
          churchDistance.id = lists[i].id;
          churchesDB.updateChurch(churchDistance);
        }
      }

      int count = await churchesDB.queryRowCount();
      print("DATABASE COUNT: $count");
    });

    FirebaseDatabase.instance
        .reference()
        .child('churches')
        .onChildRemoved
        .listen((event) async {
      Map<dynamic, dynamic> value = event.snapshot.value;

      List<ChurchDistance> lists = await churchesDB.getAllChurches();

      ChurchDistance churchDistance;
      churchDistance = ChurchDistance.fromJson(value);

      for (var i = 0; i < lists.length; i++) {
        if (lists[i].churchName == churchDistance.churchName) {
          churchesDB.deleteChurch(lists[i].id);
          print("ShowID:${lists[i].id}");
        }
      }

      int count = await churchesDB.queryRowCount();
      print("DATABASE COUNT: $count");
    });

    FirebaseDatabase.instance
        .reference()
        .child('churches')
        .onValue
        .handleError((error) => {print(error)})
        .listen((event) async {
      Map<String, dynamic> stuff = event.snapshot.value;
      List<ChurchDistance> lists = await churchesDB.getAllChurches();

      _performCheck(stuff, lists);

      int count = await churchesDB.queryRowCount();
      print("DATABASE COUNT: $count");
    });

    return churchesDB;
  }

  ChurchesDB _performCheck(Map stuff, List<ChurchDistance> lists) {
    ChurchDistance churchDistance;

    stuff.forEach((key, value) async {
      bool check = false;

      churchDistance = ChurchDistance.fromJson(value);

      for (var i = 0; i < lists.length; i++) {
        if (lists[i].churchName == churchDistance.churchName) {
          check = true;

          print("$check");
        }
      }

      if (!check) {
        print("$check");

        await churchesDB.insert(churchDistance);

        /*ChurchDistance.details(
          state: value['state'],
          churchName: value['churchName'],
          churchLat: value['churchLat'],
          churchLng: value['churchLng'],
          about: value['about'],
          address: value['address'],
          country: value['country'],
          disciples: value['disciples'],
          number: value['number'],
          pastorName: value['pastorName'],
          region: value['region'],
        )*/
      }
    });

    return churchesDB;
  }
}
