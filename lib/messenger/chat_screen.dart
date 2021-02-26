import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_church_location/models/user_object.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, this.userObject}) : super(key: key);
  final UserObject userObject;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print(widget.userObject.displayPic);
  }

  @override
  Widget build(BuildContext context) {
    double maxLines = 4;

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text(widget.userObject.username),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              child: Text("New Stuff"),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(left: 5.0, bottom: 5.0, top: 5.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(50.0)),
                  child: TextField(
                    controller: _chatController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    expands: true,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 1.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        isDense: true,
                        hintText: "Enter message...",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0))),
                  ),
                ),
              ),
              Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).accentColor),
                child: IconButton(
                    iconSize: 25.0,
                    alignment: Alignment.center,
                    color: Colors.white,
                    icon: Icon(Icons.send),
                    onPressed: () => print("Stuff")),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
