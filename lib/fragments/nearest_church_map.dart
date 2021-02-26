import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_church_location/activities/search_churches.dart';
import 'package:flutter_church_location/database/churches_db_real.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:flutter_church_location/utils/connect_to_firebase_church.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;

class NearestChurch extends StatefulWidget {
  NearestChurch({Key key}) : super(key: key);

  // final List<Map<String, dynamic>> listOfChurches =
  //     ListOfChurches().listOfChurches();

  @override
  _NearestChurchState createState() => _NearestChurchState();
}

class _NearestChurchState extends State<NearestChurch> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng currentLatLong;
  CameraPosition defaultLatLng =
      CameraPosition(target: LatLng(7.84785389917, 20.9803605602), zoom: 50);

  static bool isPermissionGranted;
  static Position lastKnownLocation, currentPosition;
  static GoogleMapController mController;
  static int counter = 0;

  Marker _marker;

  loc.Location location = loc.Location();

  // loc.LocationData _locationData;

  List<ChurchDistance> churchDistanceList = [];
  List<double> churchDistances = [];
  ChurchDistance nearestChurch;

  List<ChurchDistance> listOfChurches = [];
  ChurchesDB churchesDB;
  ChurchDistance churchObject;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    counter += 1;

    Future.delayed(
        const Duration(seconds: 5), counter == 1 ? _showMyDialog : null);
  }

  _initialize() async {
    await _confirmPermissionStatus();

    await _getLastKnownLocation();

    await _determinePosition();

    await _getChurches();
  }

  _getChurches() async {
    churchesDB = await ConnectToFirebaseChurch().getChurches();
    int count = await churchesDB.queryRowCount();
    print("DATABASE COUNT: $count");

    listOfChurches = await churchesDB.getAllChurches();

    /*churchesDB.getAllChurches().then((value) async {
      for (int i = 1; i <= value.length; i++) {
        churchObject = await churchesDB.getChurch(i);
        print("Object: ${churchObject.id}, ${churchObject.churchName}");

        // if (churchObject.userName == 'might22') print("Object: ${churchObject.userName}");
      }
    });*/
  }

  bool isMarkerOnScreen = false;

  _animateInitialCamera(GoogleMapController controller, LatLng latLng) async {
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 20)));
  }

  InfoWindow _showInfoWindow() {
    return nearestChurch != null
        ? InfoWindow(title: nearestChurch.churchName)
        : null;
  }

  LatLng _showPosition() {
    return nearestChurch != null
        ? LatLng(nearestChurch.churchLat, nearestChurch.churchLng)
        : LatLng(4.816635, 7.050708);
  }

  Marker _showMarker() {
    _marker = Marker(
        position: _showPosition(),
        markerId: MarkerId('1'),
        infoWindow: _showInfoWindow(),
        visible: isMarkerOnScreen);

    if (mController != null && nearestChurch != null) {
      mController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(nearestChurch.churchLat, nearestChurch.churchLng),
          zoom: 15)));

      /*setState(() {
        isMarkerOnScreen = true;
      });*/
    }

    return _marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: defaultLatLng,
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          markers: <Marker>{_showMarker()},
          onMapCreated: (GoogleMapController controller) async {
            mController = controller;

            await _initialize();

            await _animateInitialCamera(controller,
                LatLng(currentPosition.latitude, currentPosition.longitude));

            location.onLocationChanged.listen((event) {
              currentLatLong = LatLng(event.latitude, event.longitude);

              !isMarkerOnScreen
                  ? _animateInitialCamera(
                      controller, LatLng(event.latitude, event.longitude))
                  : null;
            });

            await _getNearestChurch();

            _controller.complete(controller);
          },
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: EdgeInsets.only(top: 50, left: 10, right: 10),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                  child: TextButton(
                child: Text(
                  "Find a location",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchChurches(listOfChurches))),
              )),
              Expanded(child: Icon(Icons.search))
            ],
          ),
        ),
      ]),
      floatingActionButton: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0, bottom: 55),
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "current_location",
                child: Icon(Icons.my_location),
                onPressed: () {
                  if (mController != null) {
                    mController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(currentLatLong.latitude,
                                currentLatLong.longitude),
                            zoom: 20)));
                  }
                },
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).accentColor,
                mini: false,
              ),
              SizedBox(
                height: 15,
              ),
              FloatingActionButton(
                heroTag: "nearest_church",
                child: Icon(Icons.location_searching),
                onPressed: () {
                  if (!_marker.visible) _showMarker();
                  setState(() {
                    isMarkerOnScreen = true;
                  });
                },
                backgroundColor: Theme.of(context).accentColor,
                foregroundColor: Colors.white,
                mini: false,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Church Location'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Find the nearest church?'),
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
                if (!_marker.visible) _showMarker();
                setState(() {
                  isMarkerOnScreen = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<ChurchDistance> _getNearestChurch() async {
    loc.LocationData currentLoc = await loc.Location().getLocation();

    print('current lat: ${currentLoc.latitude}, ${currentLoc.longitude}');

    listOfChurches.forEach((element) {
      double result = Geolocator.distanceBetween(currentLoc.latitude,
          currentLoc.longitude, element.churchLat, element.churchLng);

      churchDistanceList.add(ChurchDistance(
          churchName: element.churchName,
          churchLat: element.churchLat,
          churchLng: element.churchLng,
          distance: result));

      churchDistances.add(result);

      print(result);
    });

    ChurchDistance churchDistance = _getShortestDistance(churchDistances);

    return churchDistance;
  }

  ChurchDistance _getShortestDistance(List<double> list) {
    // List.of(list).sort();
    list.sort();

    double smallest = list[0];

    String name = '';

    churchDistanceList.forEach((element) {
      if (element.distance == smallest) {
        name = element.churchName;

        nearestChurch = element;
      }
    });

    print("New List: ${[list]}");
    print("Shortest Distance: $name");

    return nearestChurch;
  }

/*
  int findMinIndex(final List<Type> xs) {
    int minIndex;
    if (xs.isEmpty) {
      minIndex = -1;
    } else {
      final Iterator<Type> itr = xs.iterator;
      Type min = itr.current +1; // first element as the current minimum
      minIndex = itr.;
      while (itr.moveNext()) {
        final T curr = itr.next();
        if (curr.compareTo(min) < 0) {
          min = curr;
          minIndex = itr.previousIndex();
        }
      }
    }
    return minIndex;
  }
*/

  Future _getLastKnownLocation() async {
    if (isPermissionGranted) {
      lastKnownLocation = await Geolocator.getLastKnownPosition();
    }

    print('Last Location: ${lastKnownLocation.latitude}');
  }

  Future _determinePosition() async {
    if (isPermissionGranted) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
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
      isPermissionGranted = false;

      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    } else {
      isPermissionGranted = true;
      print('Permission: $isPermissionGranted');
    }
  }
}
