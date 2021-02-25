import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/churches_db_real.dart';
import 'package:flutter_church_location/database/saved_user.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/utils/connect_to_firebase_church.dart';
import 'package:youtube_api/youtube_api.dart';

import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // static const String YT_KEY = "AIzaSyDBBTUH0D6eOuRvLkynRtuBirQwYU6pl9Q";
  // YoutubeAPI _youtubeAPI = YoutubeAPI(YT_KEY);
  // List<YT_API> _ytResults = [];

  @override
  void initState() {
    super.initState();

    _init();

    SavedUserDB savedUserDB = SavedUserDB.instance;

    String uid = FirebaseAuth.instance.currentUser.uid;
    if (uid != null) {
      FirebaseDatabase.instance
          .reference()
          .child("users/$uid")
          .onValue
          .listen((event) {
        UserObject userObject = UserObject.fromMap(event.snapshot.value);

        print(userObject.username);

        savedUserDB.queryRowCount().then((value) {
          if (value >= 1) {
            print("Value: $value");
            setState(() {
              savedUserDB
                  .updateUser(userObject)
                  .then((value) => print("Show: ${value.toString()}"));
            });
          }
        });
      });
    }

    // _queryDb();
  }

  _init() async {
    ChurchesDB churchesDB = await ConnectToFirebaseChurch().getChurches();
    int count = await churchesDB.queryRowCount();
    print("DATABASE COUNT: $count");

    ChurchDistance demo;

    churchesDB.getAllChurches().then((value) async {
      for (int i = 1; i <= value.length; i++) {
        demo = await churchesDB.getChurch(i);
        print("Object: ${demo.id}, ${demo.churchName}");
      }
    });
  }

  // void _queryDb() async {
  //   _ytResults = await _youtubeAPI.search('Smooth Jazz', type: 'video');
  //   setState(() {});
  //   print(_ytResults[1].title);
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
