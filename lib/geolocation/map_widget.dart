import 'dart:async';

import 'package:dct_client/jobs/send-geodata/job/send-geodata.job.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Position _position;

  Position pos;

  //todo: refactor map controller
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex;

  @override
  Widget build(BuildContext context) {
    //todo: refactor
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            intervalDuration: SEND_GEODATA_DURATION_INTERVAL)
        .listen((Position position) async {
      if (position == null) return;

      sendGeoData();

      setState(() {
        _position = position;
      });

      //todo: refactor
      final GoogleMapController controller = await _controller.future;

      var cameraPosition = CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
        zoom: 14.4746,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });

    _kGooglePlex = CameraPosition(
      target:
          //todo: fix null
          LatLng(_position?.latitude ?? 0, _position?.longitude ?? 0),
      zoom: 14.4746,
    );

    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        compassEnabled: true,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
