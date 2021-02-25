import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/verified_users_db.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/models/verified_user.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.userObject}) : super(key: key);

  final UserObject userObject;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<UserObject> discipleRequestList = [];
  List<UserObject> leaderRequestList = [];

  VerifiedUsersDB verifiedUsersDB = VerifiedUsersDB.instance;
  List<VerifiedUser> verifiedUsers = [];

  @override
  void initState() {
    super.initState();

    _getDiscipleNotifications();

    _getLeaderNotification();

    verifiedUsersDB.getAllUsers().then((value) => verifiedUsers = value);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Requests'),
          bottom: TabBar(
            tabs: [
              Tab(text: "DISCIPLES"),
              Tab(text: "LEADERS"),
              Tab(text: "VERIFIED"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _loadDiscipleNotification(),
            _loadLeaderNotification(),
            _loadVerifiedUsers(),
          ],
        ),
      ),
    );
  }

  _getDiscipleNotifications() {
    String church = widget.userObject.church;

    List lists = [];

    FirebaseDatabase.instance
        .reference()
        .child("discipleVerification/$church")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userListMap = event.snapshot.value;

        lists = userListMap.values.toList();

        lists.forEach((element) {
          UserObject userObject = UserObject.requestFromMap(element);
          FirebaseDatabase.instance
              .reference()
              .child("users/${userObject.id}/title")
              .onValue
              .listen((event) {
            userObject.title = event.snapshot.value;
          });

          discipleRequestList.add(userObject);
        });

        discipleRequestList.forEach((element) {
          FirebaseStorage.instance
              .ref("users/${element.id}/displayPic")
              .getDownloadURL()
              .then((value) {
            setState(() {
              element.displayPic = value;
            });
          });
        });
      }
    });
  }

  _getLeaderNotification() {
    String leaderCountry = widget.userObject.leaderCountry;

    List lists = [];

    FirebaseDatabase.instance
        .reference()
        .child("leaderVerification/$leaderCountry")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userListMap = event.snapshot.value;

        lists = userListMap.values.toList();

        lists.forEach((element) {
          UserObject userObject = UserObject.requestFromMap(element);
          FirebaseDatabase.instance
              .reference()
              .child("users/${userObject.id}/title")
              .onValue
              .listen((event) {
            userObject.title = event.snapshot.value;
          });
          leaderRequestList.add(userObject);
        });

        leaderRequestList.forEach((element) {
          FirebaseStorage.instance
              .ref("users/${element.id}/displayPic")
              .getDownloadURL()
              .then((value) {
            setState(() {
              element.displayPic = value;
            });
          });
        });
      }
    });
  }

  Widget _loadDiscipleNotification() => ListView.builder(
        itemCount: discipleRequestList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            final String text =
                "Do you confirm that this person is a disciple and is spiritually well enough to be allowed on the platform?";

            showDialog(
                context: context,
                builder: (context) =>
                    showRequestDialog(discipleRequestList[index], text));
          },
          child: Card(
            child: ListTile(
              leading: discipleRequestList[index].displayPic != null
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(discipleRequestList[index].displayPic))
                  : CircleAvatar(
                      child: Icon(Icons.person),
                    ),
              title: Text(discipleRequestList[index].username),
              subtitle: Text(discipleRequestList[index].fullname),
            ),
          ),
        ),
      );

  Widget _loadLeaderNotification() => ListView.builder(
        itemCount: leaderRequestList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            final String text =
                "Do you confirm that this person is a church leader?";

            showDialog(
                context: context,
                builder: (context) =>
                    showRequestDialog(leaderRequestList[index], text));
          },
          child: Card(
            child: ListTile(
              leading: leaderRequestList[index].displayPic != null
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(leaderRequestList[index].displayPic))
                  : CircleAvatar(
                      child: Icon(Icons.person),
                    ),
              title: Text(leaderRequestList[index].username),
              subtitle: Text(leaderRequestList[index].fullname),
            ),
          ),
        ),
      );

  Widget _loadVerifiedUsers() => ListView.builder(
      itemCount: verifiedUsers.length,
      itemBuilder: (context, index) => GestureDetector(onTap: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(verifiedUsers[index].fullname),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'Do you wish to revoke their access to the social platform?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        String uid = verifiedUsers[index].uid;
                        FirebaseDatabase.instance
                            .reference()
                            .child("users/$uid/titleVerification")
                            .set("false");

                        for (int i = 0; i < verifiedUsers.length; i++) {
                          verifiedUsersDB
                              .getUser(verifiedUsers[i].id)
                              .then((value) {
                            if (value.uid == uid) {
                              verifiedUsersDB.deleteUser(value.id);
                            }
                          });
                        }
                      },
                    ),
                  ],
                );
              },
              child: Card(
                child: ListTile(
                  leading: verifiedUsers[index].displayPic != null
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(verifiedUsers[index].displayPic))
                      : CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(verifiedUsers[index].username),
                  subtitle: Text(verifiedUsers[index].fullname),
                ),
              ),
            );
          }));

  Dialog showRequestDialog(UserObject request, String confirmMessage) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 600.0,
        width: 500.0,
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(request.displayPic),
              fit: BoxFit.cover,
              height: 300.0,
              width: 500.0,
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(
                request.fullname,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(
                request.church,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                confirmMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50.0,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: RaisedButton(
                        onPressed: () => _declineUserRequest(request),
                        color: Colors.red,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50.0,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: RaisedButton(
                        onPressed: () => _approveUserRequest(request),
                        color: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _declineUserRequest(UserObject userObject) {
    DatabaseReference databaseRef;

    if (userObject.title == "leader") {
      databaseRef = FirebaseDatabase.instance.reference().child(
          "leaderVerification/${userObject.leaderCountry}/${userObject.id}/status");
    } else if (userObject.title == "disciple") {
      databaseRef = FirebaseDatabase.instance.reference().child(
          "discipleVerification/${userObject.church}/${userObject.id}/status");
    }

    databaseRef.set("declined");
  }

  _approveUserRequest(UserObject userObject) {
    FirebaseDatabase.instance
        .reference()
        .child("users/${userObject.id}/titleVerification")
        .set("true");

    DatabaseReference databaseRef;

    if (userObject.title == "leader") {
      databaseRef = FirebaseDatabase.instance.reference().child(
          "leaderVerification/${userObject.leaderCountry}/${userObject.id}");
    } else {
      databaseRef = FirebaseDatabase.instance
          .reference()
          .child("discipleVerification/${userObject.church}/${userObject.id}");
    }

    VerifiedUsersDB verifiedUsersDB = VerifiedUsersDB.instance;
    verifiedUsersDB.insert(VerifiedUser.full(
        uid: userObject.id,
        displayPic: userObject.displayPic,
        fullname: userObject.fullname,
        username: userObject.username));

    databaseRef.remove();
  }
}
