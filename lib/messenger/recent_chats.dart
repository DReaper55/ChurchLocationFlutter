import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/saved_user.dart';
import 'package:flutter_church_location/messenger/login_page.dart';
import 'package:flutter_church_location/messenger/user_list_page.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/profile_fragment_screens/my_profile_page.dart';

class RecentChats extends StatefulWidget {
  RecentChats({Key key}) : super(key: key);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  Set<String> popUpMenu = {};

  String uid = FirebaseAuth.instance.currentUser.uid;
  SavedUserDB savedUserDB = SavedUserDB.instance;

  UserObject userObject;

  BuildContext _context;

  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance
        .reference()
        .child("users/$uid")
        .onValue
        .listen((event) {
      UserObject userObject = UserObject.fromMap(event.snapshot.value);
      savedUserDB.updateUser(userObject);
    });

    confirmTitleAndStatusForVerification(1);
  }

  confirmTitleAndStatusForVerification(int condition) async {
    userObject = await savedUserDB.getAllUsers();

    if (userObject.titleVerification == "true") {
      popUpMenu = {'My Profile', 'Settings', 'Sign out'};

      if (userObject.title == "leader") {
        if (uid != null) {
          FirebaseDatabase.instance
              .reference()
              .child("admins/$uid")
              .set(userObject.toMap());

          FirebaseDatabase.instance
              .reference()
              .child("leaderVerification/${userObject.leaderCountry}/$uid")
              .remove();
        }
      } else if (userObject.title == "disciple") {
        FirebaseDatabase.instance
            .reference()
            .child("discipleVerification/${userObject.church}/$uid")
            .remove();
      }
    } else {
      popUpMenu = {
        'My Profile',
        'pending verification...',
        'Settings',
        'Sign out'
      };

      _sendVerificationRequest(condition);
    }

    if (userObject.title == "leader") {
      if (userObject.titleVerification == "false") {
        FirebaseDatabase.instance.reference().child("admins/$uid").remove();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Chat"),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UserListPage())),
          ),
          PopupMenuButton(
              onSelected: _handleMenuClick,
              itemBuilder: (context) {
                return popUpMenu
                    .map((e) => PopupMenuItem<String>(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: Text(e),
                          ),
                          value: e,
                        ))
                    .toList();
              })
        ],
      ),
      body: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserListPage())),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Start new chat",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.chat,
                  color: Colors.black,
                ),
                onPressed: null)
          ],
        ),
      ),
    );
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case 'My Profile':
        FirebaseStorage.instance
            .ref("users/${userObject.id}/displayPic")
            .getDownloadURL()
            .then((value) {
          userObject.displayPic = value;
        }).then((value) {
          Navigator.of(_context).push(MaterialPageRoute(
              builder: (_context) => MyProfilePage(
                    userObject: userObject,
                  )));
        });

        break;
      case 'Verification':
        confirmTitleAndStatusForVerification(0);
        break;
      case 'Settings':
        break;
      case 'Sign out':
        FirebaseAuth.instance.signOut().whenComplete(() =>
            Navigator.of(_context).pushReplacement(
                MaterialPageRoute(builder: (_context) => LoginPage())));
        break;
    }
  }

  void _sendVerificationRequest(int condition) {
    DatabaseReference databaseRef;
    if (userObject.title == "leader") {
      databaseRef = FirebaseDatabase.instance
          .reference()
          .child("leaderVerification/${userObject.leaderCountry}/$uid");
    } else {
      databaseRef = FirebaseDatabase.instance
          .reference()
          .child("discipleVerification/${userObject.church}/$uid");
    }

    databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("Here");
        if (userObject.title == "leader") {
          DatabaseReference db = FirebaseDatabase.instance.reference().child(
              "leaderVerification/${userObject.leaderCountry}/$uid/status");

          db.onValue.listen((event) {
            if (event.snapshot.value == "declined") {
              if (condition == 0) {
                db.set("pending");

                condition = 2;

                setState(() {
                  popUpMenu = {
                    'My Profile',
                    'pending verification...',
                    'Settings',
                    'Sign out'
                  };
                });
              } else if (condition == 1) {
                setState(() {
                  popUpMenu = {'My Profile', 'Settings', 'Sign out'};
                });
              }
            }
          });
        } else if (userObject.title == "disciple") {
          DatabaseReference db = FirebaseDatabase.instance
              .reference()
              .child("discipleVerification/${userObject.church}/$uid/status");

          db.onValue.listen((event) {
            if (event.snapshot.value == "declined") {
              if (condition == 0) {
                db.set("pending");

                setState(() {
                  condition = 2;

                  popUpMenu = {
                    'My Profile',
                    'pending verification...',
                    'Settings',
                    'Sign out'
                  };
                });
              } else if (condition == 1) {
                setState(() {
                  popUpMenu = {
                    'My Profile',
                    'Verification',
                    'Settings',
                    'Sign out'
                  };
                });
              }
            }
          });
        }
      } else {
        print("Get here");
        if (userObject.title == "leader") {
          userObject.status = "pending";
          databaseRef.set(userObject.requestToMap());
        } else {
          userObject.status = "pending";
          databaseRef.set(userObject.requestToMap());
        }

        setState(() {
          popUpMenu = {
            'My Profile',
            'pending verification...',
            'Settings',
            'Sign out'
          };
        });
      }
    });
  }
}
