import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/messenger/user_info_page.dart';
import 'package:flutter_church_location/models/user_object.dart';

class UserListPage extends StatefulWidget {
  UserListPage({Key key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserObject> userObjectList = [];
  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();

    _loadUsersFromFirebase();

    print(userObjectList);
  }

  _loadUsersFromFirebase() {
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        // UserObject userObject = UserObject.fromMap(event.snapshot.value);

        Map userMap = event.snapshot.value;

        userMap.forEach((key, value) {
          UserObject userObject = UserObject.fromMap(value);
          if (userObject.id != uid) {
            setState(() {
              userObjectList.add(userObject);
              print(userObjectList);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
      ),
      body: ListView.builder(
        itemCount: userObjectList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            FirebaseDatabase.instance
                .reference()
                .child("users/$uid/titleVerification")
                .onValue
                .listen((event) {
              if (event.snapshot.value == "true") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                          userObject: userObjectList[index],
                        )));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Verify your title first"),
                ));
              }
            });
          },
          child: Card(
            margin: EdgeInsets.only(bottom: .7),
            child: ListTile(
              leading: _showDisplayPic(index),
              title: Text(userObjectList[index].username),
              subtitle: Text(userObjectList[index].fullname),
            ),
          ),
        ),
      ),
    );
  }

  CircleAvatar _showDisplayPic(int index) {
    FirebaseStorage.instance
        .ref("users/${userObjectList[index].id}/displayPic")
        .getDownloadURL()
        .then((value) {
      setState(() {
        userObjectList[index].displayPic = value;
      });
    });

    return userObjectList[index].displayPic != null
        ? CircleAvatar(
            backgroundImage: NetworkImage(userObjectList[index].displayPic))
        : CircleAvatar(child: Icon(Icons.person));
  }
}
