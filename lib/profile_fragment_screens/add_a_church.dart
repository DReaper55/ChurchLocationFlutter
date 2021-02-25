import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geolocator/geolocator.dart';

class AddAChurch extends StatefulWidget {
  AddAChurch({Key key}) : super(key: key);

  @override
  _AddAChurchState createState() => _AddAChurchState();
}

class _AddAChurchState extends State<AddAChurch> {
  static Position currentPosition;
  static BuildContext buildContext;

  TextEditingController _regionName, _leaderName, _leaderNumber, _churchAddress;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _confirmPermissionStatus();
  }

  @override
  void dispose() {
    _regionName.dispose();
    _leaderName.dispose();
    _leaderNumber.dispose();
    _churchAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Share Location"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () => showDialog(
              context: context, builder: (context) => showChurchDialog()),
        ),
      ),
    );
  }

  Dialog showChurchDialog() {
    _regionName = TextEditingController();
    _leaderNumber = TextEditingController();
    _leaderName = TextEditingController();
    _churchAddress = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 460.0,
        width: 500.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Share Church Location",
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
            ),
            //
            //.......................Region Name......................
            //
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _regionName,
                autocorrect: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  hintText: "Region Name",
                ),
              ),
            ),
            //
            //.......................Leader Name......................
            //
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _leaderName,
                autocorrect: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(hintText: "Leader Name"),
              ),
            ),
            //
            //.......................Leader Number......................
            //
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _leaderNumber,
                autocorrect: true,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(hintText: "Leader's Number"),
              ),
            ),
            //
            //.......................Church Address......................
            //
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _churchAddress,
                autocorrect: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(hintText: "Church address"),
              ),
            ),
            //
            //.......................Button......................
            //
            Container(
              width: 500.0,
              color: Colors.blue,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                  minWidth: 500.0,
                  onPressed: () async {
                    if (_regionName.value.text != null &&
                        _regionName.value.text != "") {
                      await sendEmail();
                      Navigator.of(buildContext).pop();
                    }
                  },
                  child: Text(
                    'SHARE',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  )),
            )
          ],
        ),
      ),
    );
  }

  sendEmail() async {
    String region = _regionName.value.text;
    String pName = _leaderName.value.text;
    String churchAdd = _churchAddress.value.text;
    String leaderNum = _leaderNumber.value.text;

    final Email email = currentPosition != null
        ? Email(
            subject: "Church Location",
            recipients: ['sharechurch61@gmail.com'],
            isHTML: false,
            body: '''
        Region: $region,
        Leader Name: $pName,
        Leader Number: $leaderNum,
        Church Address: $churchAdd,
        Latitude: ${currentPosition.latitude},
        Longitude: ${currentPosition.longitude}
      ''')
        : null;

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
      print(error.toString());
    }

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  Future _confirmPermissionStatus() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }
}
