import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/saved_user.dart';
import 'package:flutter_church_location/fragments/home.dart';
import 'package:flutter_church_location/fragments/hymns_fragment.dart';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter_church_location/messenger/login_page.dart';
import 'package:flutter_church_location/messenger/recent_chats.dart';
import 'dart:io' show Platform;

import 'fragments/nearest_church_map.dart';
import 'fragments/profile_fragment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  firebase_core.FirebaseApp app = await firebase_core.Firebase.initializeApp();

  // await firebase_core.Firebase.initializeApp(
  //     name: "db",
  //     options: Platform.isAndroid
  //         ? firebase_core.FirebaseOptions(
  //             appId: "1:49753107507:android:0575fd02a1ab14e13d4746",
  //             apiKey: "AIzaSyDxO68RCRI9YMSAa6JbANuLrtZJJvJ_6V8",
  //             projectId: "kotlinchat-98d72",
  //             databaseURL: "https://kotlinchat-98d72.firebaseio.com")
  //         : null);
  runApp(MyApp(app: app));
}

class MyApp extends StatelessWidget {
  MyApp({firebase_core.FirebaseApp app});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: "Church Location",
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  // HomePage({firebase_core.FirebaseApp app});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedCurrentIndex = 0;

  // current screen
  var _currentTab;

  SavedUserDB _savedUser = SavedUserDB.instance;

  _selectTab(int index) {
    setState(() {
      _selectedCurrentIndex = index;
    });
  }

  Widget _body(int pageIndex) {
    Widget widget;

    switch (pageIndex) {
      case 0:
        _currentTab = Home();

        widget = _currentTab;
        print(pageIndex);
        return widget;
        break;
      case 1:
        _currentTab = HymnsFragment();
        widget = _currentTab;
        return widget;
        break;
      case 2:
        _currentTab = NearestChurch();
        widget = _currentTab;
        return widget;
        break;
      case 3:
        _savedUser.queryRowCount().then((value) {
          if (value >= 1 && FirebaseAuth.instance.currentUser != null) {
            setState(() {
              _currentTab = RecentChats();
            });
          } else {
            setState(() {
              _currentTab = LoginPage();
            });
          }
        });
        widget = _currentTab;
        return widget;
        break;
      case 4:
        _currentTab = ProfileFragment();
        widget = _currentTab;
        return widget;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(_selectedCurrentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedCurrentIndex,
        showUnselectedLabels: false,
        onTap: (index) => _selectTab(index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Hymns",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_searching),
            label: "Location",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "More",
          ),
        ],
      ),
    );
  }
}
