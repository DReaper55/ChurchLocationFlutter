import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/verified_users_db.dart';
import 'package:flutter_church_location/models/verified_user.dart';

class VerifiedUsersPage extends StatefulWidget {
  VerifiedUsersPage({Key key}) : super(key: key);

  @override
  _VerifiedUsersPageState createState() => _VerifiedUsersPageState();
}

class _VerifiedUsersPageState extends State<VerifiedUsersPage> {
  VerifiedUsersDB verifiedUsersDB = VerifiedUsersDB.instance;
  List<VerifiedUser> verifiedUsers = [];

  @override
  void initState() {
    super.initState();

    verifiedUsersDB.getAllUsers().then((value) => verifiedUsers = value);
  }

  @override
  Widget build(BuildContext context) {
    return verifiedUsers.length >= 1
        ? ListView.builder(
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
                                backgroundImage: NetworkImage(
                                    verifiedUsers[index].displayPic))
                            : CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(verifiedUsers[index].username),
                        subtitle: Text(verifiedUsers[index].fullname),
                      ),
                    ),
                  );
                }))
        : Container();
  }
}
