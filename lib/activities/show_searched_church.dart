import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowSearchedChurch extends StatelessWidget {
  final ChurchDistance _churchLocation;

  ShowSearchedChurch(this._churchLocation);

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          _churchLocation.churchLat, _churchLocation.churchLng),
                      zoom: 18),
                  compassEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.hybrid,
                  markers: _showMarker(),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);

                    // print(_churchLocation);
                  },
                ),
                Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Theme.of(context).accentColor),
                  margin: EdgeInsets.only(left: 20.0, top: 50.0),
                  child: IconButton(
                      iconSize: 20.0,
                      padding: EdgeInsets.only(left: 5.0),
                      alignment: Alignment.center,
                      color: Colors.white70,
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context)),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _churchLocation.churchName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          _churchLocation.pastorName,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            onPressed: null),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  width: 380,
                  height: .7,
                  child: ColoredBox(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Text(
                    "Church Address",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.redAccent, fontSize: 23),
                  ),
                ),
                Text(
                  _churchLocation.address,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  "${_churchLocation.state}, ${_churchLocation.country}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                  child: Text(
                    "${_churchLocation.churchLat}, ${_churchLocation.churchLng}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 380,
                  height: .7,
                  child: ColoredBox(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    "About",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange, fontSize: 23),
                  ),
                ),
                Text(
                  _churchLocation.about,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Set<Marker> _showMarker() {
    Set<Marker> markers = {};

    markers.add(Marker(
        position: LatLng(_churchLocation.churchLat, _churchLocation.churchLng),
        markerId: MarkerId('1'),
        infoWindow: InfoWindow(title: _churchLocation.churchName),
        visible: true));

    // listOfChurches.forEach((element) {
    //   markers.add(Marker(
    //       position: LatLng(double.parse(element['churchLat']),
    //           double.parse(element['churchLng'])),
    //       markerId: MarkerId('1'),
    //       infoWindow: InfoWindow(title: element['churchName']),
    //       visible: true));
    // });

    return markers;
  }
}
