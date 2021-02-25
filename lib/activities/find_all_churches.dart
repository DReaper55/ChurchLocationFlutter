import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_church_location/models/church_distance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FindAllChurches extends StatelessWidget {
  final List<ChurchDistance> listOfChurches;

  FindAllChurches(this.listOfChurches);

  final List<BitmapDescriptor> colors = [
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
  ];

  BuildContext _context;
  Set<Marker> markers = {};
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    _context = context;

    Completer<GoogleMapController> _controller = Completer();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    listOfChurches[0].churchLat, listOfChurches[0].churchLng),
                zoom: 4),
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            markers: _showMarker(),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _controller.complete(controller);
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
    );
  }

  Set<Marker> _showMarker() {
    listOfChurches.forEach((element) {
      markers.add(Marker(
          icon: colors[Random.secure().nextInt(colors.length)],
          position: LatLng(element.churchLat, element.churchLng),
          markerId: MarkerId("${element.churchName}"),
          infoWindow: InfoWindow(
              title: element.churchName,
              snippet: "click for more info",
              onTap: () => _showBottomDialogSheet(element.churchName)),
          visible: true));
    });

    return markers;
  }

  Widget _showBottomBody(String id) {
    Widget container;

    if (_mapController.isMarkerInfoWindowShown(MarkerId(id)) != null) {
      listOfChurches.forEach((element) {
        if (element.churchName == id) {
          container = Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    element.churchName,
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
                          element.pastorName,
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
                  element.address,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  "${element.state}, ${element.country}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                  child: Text(
                    "${element.churchLat}, ${element.churchLng}",
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Text(
                    element.about,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                )
              ],
            ),
          );
        }
      });
    }

    return container;
  }

  void _showBottomDialogSheet(String id) => showMaterialModalBottomSheet(
        context: _context,
        enableDrag: true,
        isDismissible: true,
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          scrollDirection: Axis.vertical,
          child: _showBottomBody(id),
        ),
      );
}
