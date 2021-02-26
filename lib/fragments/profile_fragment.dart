import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/saved_user.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/profile_fragment_screens/add_a_church.dart';
import 'package:flutter_church_location/profile_fragment_screens/my_profile_page.dart';
import 'package:flutter_church_location/profile_fragment_screens/notifications_page.dart';

class ProfileFragment extends StatefulWidget {
  ProfileFragment({Key key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  User user = FirebaseAuth.instance.currentUser;
  String _image;

  bool isVerified = false;

  SavedUserDB savedUser = SavedUserDB.instance;

  UserObject _userObject;

  @override
  void initState() {
    super.initState();

    _checkTitleVerificationStatus();

    if (user != null) {
      FirebaseStorage.instance
          .ref("users/${user.uid}/displayPic")
          .getDownloadURL()
          .then((value) {
        setState(() {
          _image = value;
          _userObject.displayPic = value;
        });
      });
    }

    savedUser.getAllUsers().then((value) {
      print(value.email);
      setState(() {
        _userObject = value;
      });
    });

    if (user != null) {
      FirebaseDatabase.instance
          .reference()
          .child("users/${user.uid}")
          .onValue
          .listen((event) {
        UserObject userObject = UserObject.fromMap(event.snapshot.value);

        print(userObject.username);

        savedUser.queryRowCount().then((value) {
          if (value >= 1) {
            print("Value: $value");
            setState(() {
              savedUser
                  .updateUser(userObject)
                  .then((value) => print("Show: ${value.toString()}"));
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
            child: CircleAvatar(
                radius: 70.0,
                child: _image == null
                    ? Container(
                        child: Icon(
                          Icons.person,
                          size: 50.0,
                        ),
                      )
                    : null,
                backgroundImage: _image != null ? NetworkImage(_image) : null),
          ),
          SizedBox(
            height: 400.0,
            child: SingleChildScrollView(
              child: Card(
                child: Column(
                  children: [
                    //
                    //..................Notification................//
                    //
                    isVerified
                        ? Container(
                            height: 80.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              leading: Icon(
                                Icons.notifications_active,
                                size: 28.0,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Notification",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 23),
                              ),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NotificationsPage(
                                            userObject: _userObject,
                                          ))),
                            ),
                          )
                        : Container(),
                    //
                    //.......................My Profile...............
                    //
                    Container(
                      height: 80.0,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(
                          Icons.people,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        title: Text(
                          "My Profile",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfilePage(
                                      userObject: _userObject,
                                    ))),
                      ),
                    ),
                    Container(
                      //
                      //..................Add Church................//
                      //
                      height: 80.0,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(
                          Icons.my_location,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Add A Church",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAChurch())),
                      ),
                    ),
                    Container(
                      //
                      //..................Share................//
                      //
                      height: 80.0,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(
                          Icons.share,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Share",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        ),
                        onTap: () => null,
                      ),
                    ),
                    Container(
                      //
                      //..................Videos................//
                      //
                      height: 80.0,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(
                          Icons.video_collection,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Videos",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        ),
                        onTap: () => null,
                      ),
                    ),
                    Container(
                      //
                      //..................Settings................//
                      //
                      height: 80.0,
                      alignment: Alignment.center,
                      child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Settings",
                          style: TextStyle(color: Colors.black, fontSize: 23),
                        ),
                        onTap: () => null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkTitleVerificationStatus() {
    savedUser.getAllUsers().then((value) {
      if (value.title == "leader" && value.titleVerification == "true") {
        setState(() {
          isVerified = true;
        });
      }
    });
  }
}
