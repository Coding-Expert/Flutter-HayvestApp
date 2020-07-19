import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectMap extends StatefulWidget {
  Position position;

  SelectMap(this.position);

  @override
  _SelectMapState createState() => _SelectMapState();
}

class _SelectMapState extends State<SelectMap> {
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick farm Location"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.position.latitude, widget.position.longitude),
                zoom: 10.0),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller = controller;
              });

            },
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            trackCameraPosition: true,

          ),
          Positioned(
            bottom: 50.0,
            child: new SizedBox(
              height: 50.0,
              child: new RaisedButton(
                onPressed: () {},
                child: Text("Pick this Location"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
