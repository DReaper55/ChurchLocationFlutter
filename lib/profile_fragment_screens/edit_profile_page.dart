import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/database/saved_user.dart';
import 'package:flutter_church_location/models/user_object.dart';
import 'package:flutter_church_location/profile_fragment_screens/my_profile_page.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key, this.userObject}) : super(key: key);

  final UserObject userObject;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _fullNameCtrl;
  TextEditingController _userNameCtrl;
  TextEditingController _hobbies;
  TextEditingController _userBio;

  String _title;

  BuildContext _context;

  @override
  void initState() {
    super.initState();

    _title = widget.userObject.title;

    _fullNameCtrl = TextEditingController(text: widget.userObject.fullname);
    _userNameCtrl = TextEditingController(text: widget.userObject.username);
    if (widget.userObject.hobby == "N/A") {
      _hobbies = TextEditingController();
    } else {
      _hobbies = TextEditingController(text: widget.userObject.hobby);
    }

    if (widget.userObject.bio == "N/A") {
      _userBio = TextEditingController();
    } else {
      _userBio = TextEditingController(text: widget.userObject.bio);
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Profile Picture",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                      onPressed: getImage,
                      child: Text(
                        "Edit",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: _loadDisplayPic(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              height: .7,
              child: ColoredBox(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
              child: TextField(
                controller: _fullNameCtrl,
                decoration: InputDecoration(
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.auto),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
              child: TextField(
                controller: _userNameCtrl,
                decoration: InputDecoration(
                    labelText: "Username",
                    floatingLabelBehavior: FloatingLabelBehavior.auto),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  //
                  //..................Leader Title.............
                  //
                  Expanded(
                    child: ListTile(
                      title: Text("Leader"),
                      leading: Radio(
                        groupValue: _title,
                        value: "leader",
                        onChanged: (String value) {
                          setState(() {
                            _title = value;
                            print(_title);
                          });
                        },
                      ),
                    ),
                  ),
                  //
                  //................Disciple Title.............
                  //
                  Expanded(
                    child: ListTile(
                      title: Text("Disciple"),
                      leading: Radio(
                        groupValue: _title,
                        value: "disciple",
                        onChanged: (String value) {
                          setState(() {
                            _title = value;
                            print(_title);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              height: .7,
              child: ColoredBox(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Hobbies",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              height: 60.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.9),
                  borderRadius: BorderRadius.circular(5.0)),
              child: TextField(
                controller: _hobbies,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "E.g dancing, singing, playing basketball...",
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                "Bio",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 20.0, bottom: 100.0),
              height: 120.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.9),
                  borderRadius: BorderRadius.circular(5.0)),
              child: TextField(
                maxLines: 4,
                controller: _userBio,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: "you can describe yourself...",
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveUserToDB,
        child: Icon(Icons.check),
      ),
    );
  }

  File _image;
  final picker = ImagePicker();

  _saveUserToDB() {
    String uid = widget.userObject.id;

    String fullname = _fullNameCtrl.value.text;
    String username = _userNameCtrl.value.text;
    String hobby = _hobbies.value.text;
    String bio = _userBio.value.text;

    SavedUserDB savedUser = SavedUserDB.instance;

    String displayPicUrl;

    if (_image != null) {
      FirebaseStorage.instance.ref("users/$uid/displayPic").putFile(_image);
    }

    FirebaseDatabase.instance
        .reference()
        .child("users/$uid/fullname")
        .set(fullname);
    FirebaseDatabase.instance.reference().child("users/$uid/title").set(_title);
    FirebaseDatabase.instance
        .reference()
        .child("users/$uid/username")
        .set(username);
    FirebaseDatabase.instance.reference().child("users/$uid/hobby").set(hobby);
    FirebaseDatabase.instance
        .reference()
        .child("users/$uid/bio")
        .set(bio)
        .then((value) {
      FirebaseDatabase.instance
          .reference()
          .child("users/$uid")
          .onValue
          .listen((event) {
        UserObject userObject = UserObject.fromMap(event.snapshot.value);

        FirebaseStorage.instance
            .ref("users/$uid/displayPic")
            .getDownloadURL()
            .then((value) {
          displayPicUrl = value;

          userObject.displayPic = displayPicUrl;

          print("Url: $displayPicUrl");

          savedUser.updateUser(userObject).whenComplete(
              () => Navigator.of(_context).pushReplacement(MaterialPageRoute(
                  builder: (_context) => MyProfilePage(
                        userObject: userObject,
                      ))));
        });
      });
    });
  }

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

  CircleAvatar _loadDisplayPic() {
    CircleAvatar circleAvatar;
    if (_image == null) {
      circleAvatar = CircleAvatar(
          radius: 70.0,
          child: widget.userObject.displayPic == null
              ? Container(
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                  ),
                )
              : null,
          backgroundImage: widget.userObject.displayPic != null
              ? NetworkImage(widget.userObject.displayPic)
              : null);
    } else {
      circleAvatar =
          CircleAvatar(radius: 70.0, backgroundImage: FileImage(_image));
    }

    return circleAvatar;
  }
}
