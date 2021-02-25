import 'package:flutter/material.dart';
import 'package:flutter_church_location/models/user_object.dart';

import 'package:intl/intl.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key, this.userObject}) : super(key: key);

  final UserObject userObject;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Info"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            //........................Display Pic............................
            //
            Container(
              height: 250.0,
              width: MediaQuery.of(context).size.width,
              child: widget.userObject.displayPic != null
                  ? Image(
                      image: NetworkImage(widget.userObject.displayPic),
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person,
                      size: 50.0,
                    ),
            ),
            //
            //........................Full Name............................
            //
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  widget.userObject.fullname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold),
                )),
            //
            //........................Username............................
            //
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  widget.userObject.username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )),
            //
            //........................Email............................
            //
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  widget.userObject.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                )),
            //
            //........................Line............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: .7,
                child: ColoredBox(
                  color: Colors.black,
                ),
              ),
            ),
            //
            //........................Membership............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Membership:",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.userObject.church,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //........................Current country............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Current country:",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.userObject.leaderCountry,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //........................Current state............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Current state:",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.userObject.state,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //........................Line............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: .7,
                child: ColoredBox(
                  color: Colors.black,
                ),
              ),
            ),
            //
            //........................Gender............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Gender:",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.userObject.gender,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //........................Date of birth............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Date of Birth",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      DateFormat("MMMM d, y").format(
                          DateTime.parse(widget.userObject.dateOfBirth)),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //........................Date of baptism............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Date of baptism:",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      DateFormat("MMMM d, y").format(
                          DateTime.parse(widget.userObject.dateOfBaptism)),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //........................Line............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: .7,
                child: ColoredBox(
                  color: Colors.black,
                ),
              ),
            ),
            //
            //........................Hobbies............................
            //
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hobbies",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0),
                    child: Text(
                      widget.userObject.hobby,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
            //
            //........................Line............................
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: .7,
                child: ColoredBox(
                  color: Colors.black,
                ),
              ),
            ),
            //
            //........................Bio............................
            //
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Bio",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0),
                    child: Text(
                      widget.userObject.bio,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Icon(Icons.chat),
      ),
    );
  }
}
