import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/churches_db_real.dart';
import 'package:flutter_church_location/messenger/login_page.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/utils/connect_to_firebase_church.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key, this.listOfChurches}) : super(key: key);

  final List<ChurchDistance> listOfChurches;

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _fullNameCtrl, _emailCtrl, _userNameCtrl, _passwordCtrl;

  Color leaderBackColor = Colors.black12;
  Color discipleBackColor = Colors.black12;
  Color leaderTextColor = Colors.black;
  Color discipleTextColor = Colors.black;

  String _gender;

  bool isPasswordVisible = true;

  String churchDenomination;
  String churchCountry, churchState;

  List<String> _churchCountry = [];
  List<String> _churchDenomination = [];
  List<String> _churchState = [];

  @override
  void initState() {
    super.initState();

    _fullNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _userNameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();

    retrieveChurchCountry();
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _userNameCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  File _image;
  final picker = ImagePicker();

  DateTime currentDOBirth = DateTime(2000);
  DateTime currentDOBaptism = DateTime(2021);

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(.5)),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                        child: GestureDetector(
                          onTap: getImage,
                          child: CircleAvatar(
                              radius: 70.0,
                              child: _image == null
                                  ? Container(
                                      child: Text(
                                        "SELECT IMAGE",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : null,
                              backgroundImage:
                                  _image != null ? FileImage(_image) : null),
                        ),
                      ),
                      Card(
                        child: Column(
                          children: [
                            //
                            //.................Full Name.................
                            //
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              height: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.9),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: TextFormField(
                                controller: _fullNameCtrl,
                                validator: (value) {
                                  if (value.length <= 5)
                                    return "Input your full name";
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: "Full Name",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ),
                            //
                            //  .........................Email...............
                            //
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              height: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.9),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: TextFormField(
                                controller: _emailCtrl,
                                validator: (value) {
                                  bool check = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!check) return "Input proper email";
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ),
                            //
                            //  .........................Username...............
                            //
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              height: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.9),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: TextFormField(
                                controller: _userNameCtrl,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.length == 0)
                                    return "Input username";
                                },
                                decoration: InputDecoration(
                                    hintText: "Username",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ),
                            //
                            //  .........................Password...............
                            //
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              height: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.9),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: TextFormField(
                                controller: _passwordCtrl,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: isPasswordVisible,
                                validator: (value) {
                                  if (value.length < 6)
                                    return "Password cannot be less that 6";
                                },
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
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                //
                                //...................Leader CheckBox..............
                                //
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      // focusColor: Colors.blue,
                                      color: leaderBackColor,
                                      onPressed: () {
                                        if (discipleBackColor != Colors.blue) {
                                          if (leaderBackColor ==
                                              Colors.black12) {
                                            setState(() {
                                              leaderBackColor = Colors.blue;
                                              leaderTextColor = Colors.white;
                                            });
                                          } else {
                                            setState(() {
                                              leaderBackColor = Colors.black12;
                                              leaderTextColor = Colors.black;
                                            });
                                          }
                                        }
                                      },
                                      child: Text(
                                        "Leader",
                                        style:
                                            TextStyle(color: leaderTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                                //
                                //...................Disciple CheckBox..............
                                //
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                        color: discipleBackColor,
                                        onPressed: () {
                                          if (leaderBackColor != Colors.blue) {
                                            if (discipleBackColor ==
                                                Colors.black12) {
                                              setState(() {
                                                discipleBackColor = Colors.blue;
                                                discipleTextColor =
                                                    Colors.white;
                                              });
                                            } else {
                                              setState(() {
                                                discipleBackColor =
                                                    Colors.black12;
                                                discipleTextColor =
                                                    Colors.black;
                                              });
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Disciple",
                                          style: TextStyle(
                                              color: discipleTextColor),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                //
                                //..................Male Gender.............
                                //
                                Expanded(
                                  child: ListTile(
                                    title: Text("Male"),
                                    leading: Radio(
                                      groupValue: _gender,
                                      value: "Male",
                                      onChanged: (String value) {
                                        setState(() {
                                          _gender = value;
                                          print(_gender);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                //
                                //................Female Gender.............
                                //
                                Expanded(
                                  child: ListTile(
                                    title: Text("Female"),
                                    leading: Radio(
                                      groupValue: _gender,
                                      value: "Female",
                                      onChanged: (String value) {
                                        setState(() {
                                          _gender = value;
                                          print(_gender);
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            //
                            //.................Date of Birth Input..........
                            //
                            Row(
                              children: [
                                FlatButton(
                                    onPressed: () =>
                                        _selectDateOfBirth(context),
                                    child: Text("Date Of Birth")),
                                TextButton(
                                    onPressed: () =>
                                        _selectDateOfBirth(context),
                                    child: Text(DateFormat('yyyy, MM, dd')
                                        .format(currentDOBirth))),
                              ],
                            ),
                            Row(
                              children: [
                                FlatButton(
                                    onPressed: () =>
                                        _selectDateOfBaptism(context),
                                    child: Text("Date Of Baptism")),
                                TextButton(
                                    onPressed: () =>
                                        _selectDateOfBaptism(context),
                                    child: Text(DateFormat('yyyy, MM, dd')
                                        .format(currentDOBaptism))),
                              ],
                            ),
                            //
                            //.................Date of Baptism Input..........
                            //
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          //
                          //.....................Find churches Country................
                          //
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: DropdownButton<String>(
                                value: churchCountry,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                onChanged: (String data) {
                                  setState(() {
                                    churchCountry = data;
                                    retrieveChurchState(data);
                                  });
                                },
                                items: _churchCountry
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            //
                            //.....................Find churches State................
                            //
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: DropdownButton<String>(
                                value: churchState,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                onChanged: (String data) {
                                  setState(() {
                                    churchState = data;
                                    retrieveDenomination(data);
                                  });
                                },
                                items: _churchState
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            //
                            //.....................Find churches Denomination................
                            //
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: DropdownButton<String>(
                                value: churchDenomination,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                onChanged: (String data) {
                                  setState(() {
                                    churchDenomination = data;
                                  });
                                },
                                items: _churchDenomination
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      //....................Register Button.................
                      //
                      Container(
                        width: MediaQuery.of(context).size.width - 10,
                        margin: EdgeInsets.only(top: 30.0),
                        height: 55.0,
                        child: RaisedButton(
                          onPressed: () async {
                            String uid;

                            print(leaderBackColor.toString());
                            print(discipleBackColor.toString());
                            if (_formKey.currentState.validate()) {
                              if (leaderBackColor != Colors.blue &&
                                  discipleBackColor != Colors.blue) {
                                return _scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Leader or Disciple?"),
                                ));
                              }

                              if (_gender != "Male" && _gender != "Female") {
                                return _scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Select a gender"),
                                ));
                              }

                              if (churchDenomination == null) {
                                return _scaffoldKey.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Select a church denomination"),
                                ));
                              }

                              await saveUserToFirebase();
                            }
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text("REGISTER"),
                        ),
                      ),
                      //
                      //....................Login Button.................
                      //
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 100.0, bottom: 50.0),
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20.0),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<String> saveUserToFirebase() async {
    String email = _emailCtrl.value.text;
    String password = _passwordCtrl.value.text;
    String fullName = _fullNameCtrl.value.text;
    String username = _userNameCtrl.value.text;

    String title;
    if (leaderBackColor == Colors.blue) title = "leader";
    if (discipleBackColor == Colors.blue) title = "disciple";

    String gender = _gender;
    String dateOfBirth = currentDOBirth.toString();
    String dateOfBaptism = currentDOBaptism.toString();
    String leaderCountry = churchCountry;
    String state = churchState;
    String church = churchDenomination;

    String id;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      id = value.user.uid;
      String downloadedImageUrl;

      print("Uid: $id");

      if (_image != null) {
        FirebaseStorage.instance.ref("users/$id/displayPic").putFile(_image);
        // downloadedImageUrl = await imageFile.snapshot.ref.getDownloadURL();
      }

      UserObject userObject = UserObject.full(
        fullName,
        email,
        password,
        title,
        gender,
        church,
        id,
        leaderCountry,
        username,
        state,
        dateOfBirth,
        dateOfBaptism,
        "false",
        "false",
        "N/A",
        "N/A",
      );

      print(userObject.toMap());

      FirebaseDatabase.instance
          .reference()
          .child("users/$id")
          .set(userObject.toMap());

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Successfully created account"),
      ));

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(
                uid: id,
              )));
    }).catchError(() => _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Failed to create user"),
            )));

    return id;
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDOBirth,
        firstDate: DateTime(1940),
        lastDate: DateTime(2005));
    if (pickedDate != null && pickedDate != currentDOBirth)
      setState(() {
        currentDOBirth = pickedDate;
      });
  }

  Future<void> _selectDateOfBaptism(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDOBaptism,
        firstDate: DateTime(1940),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDOBaptism)
      setState(() {
        currentDOBaptism = pickedDate;
      });
  }

  retrieveChurchCountry() {
    List<String> countryList = [];
    List<String> countryCheck = [];

    widget.listOfChurches.forEach((element) {
      countryList.add(element.country);
    });

    for (int i = 0; i < countryList.length; i++) {
      String country = countryList[i];

      bool check = false;

      if (countryCheck.length >= 1 && countryCheck[0] != null) {
        for (int j = 0; j < countryCheck.length; j++) {
          if (countryCheck[j] == country) {
            check = true;
          }

          if (j == countryCheck.length - 1 && !check) {
            countryCheck.insert(j + 1, country);
          }
        }
      } else {
        countryCheck.insert(i, country);
        churchCountry = countryCheck[0];
      }
    }

    _churchCountry = List(countryCheck.length);

    for (int i = 0; i < countryCheck.length; i++) {
      _churchCountry[i] = countryCheck[i];
    }
  }

  retrieveChurchState(String country) {
    List<String> stateList = [];
    List<String> stateCheck = [];

    churchState = null;
    _churchState = [];

    if (country != null) {
      widget.listOfChurches.forEach((element) {
        if (element.country == country) {
          stateList.add(element.state);
        }
      });
    } else {
      print("Empty");
    }

    print(stateList);

    for (int i = 0; i < stateList.length; i++) {
      String state = stateList[i];

      bool check = false;

      if (stateCheck.length >= 1 && stateCheck[0] != null) {
        for (int j = 0; j < stateCheck.length; j++) {
          if (stateCheck[j] == state) {
            check = true;
          }

          if (j == stateCheck.length - 1 && !check) {
            stateCheck.insert(j + 1, state);
          }
        }
      } else {
        stateCheck.insert(i, state);
      }
    }

    _churchState = List(stateCheck.length);
    for (int i = 0; i < stateCheck.length; i++) {
      _churchState[i] = stateCheck[i];
    }
  }

  retrieveDenomination(String state) {
    List<String> denomList = [];
    churchDenomination = null;
    _churchDenomination = [];

    if (state != null) {
      widget.listOfChurches.forEach((element) {
        if (element.state == state) {
          denomList.add(element.churchName);
        }
      });
    }

    print("Church state: $churchState");

    print("Denom: $denomList");

    _churchDenomination = List(denomList.length);

    for (int i = 0; i < denomList.length; i++) {
      _churchDenomination[i] = denomList[i];
    }

    print("Church: $_churchDenomination");
  }

  DropdownButton<String> showDropdownButton(List<String> list, String update) =>
      DropdownButton<String>(
        value: update,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 18),
        onChanged: (String data) {
          setState(() {
            update = data;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
}
