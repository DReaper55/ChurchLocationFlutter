import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindAllChurches2 extends StatefulWidget {
  final List<Map<String, dynamic>> listOfChurches;

  FindAllChurches2(this.listOfChurches);

  @override
  _FindAllChurches2State createState() => _FindAllChurches2State();
}

class _FindAllChurches2State extends State<FindAllChurches2> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print([widget.listOfChurches]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    double.parse(widget.listOfChurches[0]['churchLat']),
                    double.parse(widget.listOfChurches[0]['churchLng'])),
                zoom: 4),
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            markers: _showMarker(),
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
            },
          ),
          Container(
            height: 30.0,
            width: 30.0,
            margin: EdgeInsets.only(left: 20.0, top: 50.0),
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }

  Set<Marker> _showMarker() {
    Set<Marker> markers = {};

    widget.listOfChurches.forEach((element) {
      markers.add(Marker(
          position: LatLng(double.parse(element['churchLat']),
              double.parse(element['churchLng'])),
          markerId: MarkerId(Random().nextInt(1000).toString()),
          infoWindow: InfoWindow(title: element['churchName']),
          visible: true));
    });

    return markers;
  }
}
