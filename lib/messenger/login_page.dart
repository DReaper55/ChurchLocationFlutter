import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/churches_db_real.dart';
import 'package:flutter_church_location/database/saved_user.dart';
import 'package:flutter_church_location/messenger/recent_chats.dart';
import 'package:flutter_church_location/messenger/registration_page.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/utils/connect_to_firebase_church.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController, _passwordCtrl;

  List<ChurchDistance> listOfChurches = [];
  ChurchesDB _churchesDB;
  ChurchDistance _churchObject;

  SavedUserDB _savedUser;
  UserObject _userObject;

  bool isPasswordVisible = true;

  BuildContext _context;

  @override
  void initState() {
    super.initState();

    _savedUser = SavedUserDB.instance;

    _emailController = TextEditingController();
    _passwordCtrl = TextEditingController();

    _getChurches();

    if (widget.uid != null) _checkVerificationStatus(widget.uid);
  }

  _checkVerificationStatus(String uid) {
    FirebaseDatabase.instance
        .reference()
        .child("users/$uid/emailVerification")
        .onValue
        .listen((event) {
      var value = event.snapshot.value;

      print(value.runtimeType);

      if (value == "false") _sendVerificationEmail();
    });
  }

  _sendVerificationEmail() {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification().then((value) {
        Scaffold.of(_context).showSnackBar(SnackBar(
          content: Text("Check email"),
          duration: Duration(seconds: 10),
        ));
      }).catchError(() => Scaffold.of(_context).showSnackBar(
          SnackBar(content: Text("An Error occurred, try again later"))));
    }
  }

  _getChurches() async {
    _churchesDB = await ConnectToFirebaseChurch().getChurches();
    int count = await _churchesDB.queryRowCount();
    print("DATABASE COUNT: $count");

    listOfChurches = await _churchesDB.getAllChurches();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Container(
        child: Stack(
          children: [
            Image(
              image: AssetImage('assets/images/chat.jpeg'),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(.5)),
              ),
            ),
            //
            //......................Email........................
            //
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Container(
                    height: 60.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.9),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextField(
                      autocorrect: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                      ),
                    ),
                  ),
                ),
                //
                //......................Password........................
                //
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
                  child: Container(
                    height: 60.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.9),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      autocorrect: true,
                      controller: _passwordCtrl,
                      obscureText: isPasswordVisible,
                      decoration: InputDecoration(
                        suffixIcon: isPasswordVisible
                            ? IconButton(
                                icon: Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = false;
                                  });
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = true;
                                  });
                                },
                              ),
                        hintText: "Password",
                      ),
                    ),
                  ),
                ),
                //
                //......................Forgot Password........................
                //
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    onPressed: _retrievePassword,
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
                ),
                //
                //......................Login........................
                //
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  margin: EdgeInsets.only(top: 20.0),
                  height: 55.0,
                  child: RaisedButton(
                    onPressed: _signInAccount,
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("LOGIN"),
                  ),
                ),
                //
                //......................Sign Up........................
                //
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage(
                                  listOfChurches: [...this.listOfChurches],
                                ))),
                    child: Text(
                      "Don't have an account? SIGN UP",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signInAccount() {
    String email = _emailController.value.text;
    String password = _passwordCtrl.value.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        String uid = value.user.uid;

        if (value.user != null) {
          if (value.user.emailVerified) {
            FirebaseDatabase.instance
                .reference()
                .child("users/$uid/emailVerification")
                .set("true");

            FirebaseDatabase.instance
                .reference()
                .child("users/$uid")
                .onValue
                .listen((event) {
              if (event.snapshot != null) {
                UserObject userObject =
                    UserObject.fromMap(event.snapshot.value);
                print("UserObject: ${userObject.fullname}");

                assert(userObject != null);
                _savedUser.insert(userObject);
              }
            });

            _savedUser.queryRowCount().then((value) => print(value));

            Navigator.of(_context).pushReplacement(
                MaterialPageRoute(builder: (_context) => RecentChats()));
          }
        } else {
          _sendVerificationEmail();
        }
      });
    }
  }

  void _retrievePassword() {
    String email = _emailController.value.text;

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) =>
        Scaffold.of(_context).showSnackBar(
            SnackBar(content: Text("Check Email to reset password"))));
  }
}
