import 'dart:async';

import 'package:dct_client/jobs/get_status_and_locations.job.dart';
import 'package:dct_client/jobs/send-geodata.job.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import 'dtos/get_locations.dto.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  StreamSubscription<Position> _positionStreamSubscription;
  Position _position;
  CrowdStatus _status;

  //todo: refactor
  Set<Circle> _circles = {};

  //todo: refactor map controller
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex;

  Color _resolveStatusColor() {
    //todo: check colors
    switch (_status) {
      case CrowdStatus.good:
        return Colors.green;

      case CrowdStatus.ok:
        return Colors.yellow;

      case CrowdStatus.bad:
        return Colors.red;

      default:
        return Colors.red;
    }
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //todo: refactor
    _positionStreamSubscription = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            intervalDuration: SEND_GEODATA_DURATION_INTERVAL)
        .listen((Position position) async {
      if (position == null) return;

      sendGeoData();
      var dto = await getStatusAndLocations();
      setState(() {
        _position = position;
        _status = dto.status;

        _circles = dto.locations.asMap().entries.map((entry) {
          var l = entry.value;
          var i = entry.key;

          var circle = Circle(
            circleId: CircleId("circle_id:$i"),
            strokeColor: Colors.red,
            fillColor: Colors.orange,
            strokeWidth: 2,
            center: LatLng(l.latitude, l.longitude),
            radius: 15,
          );

          return circle;
        }).toSet();
      });

      // //todo: refactor
      // final GoogleMapController controller = await _controller.future;
      //
      // var cameraPosition = CameraPosition(
      //   target: LatLng(
      //     position.latitude,
      //     position.longitude,
      //   ),
      //   zoom: 15,
      // );
      //
      // controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    _kGooglePlex = CameraPosition(
      target:
          //todo: fix null
          LatLng(_position?.latitude ?? 0, _position?.longitude ?? 0),
      zoom: 15,
    );

    if (_position == null) {
      return CircularProgressIndicator(
        backgroundColor: Colors.blue,
      );
    }

    return new Scaffold(
        body: Container(
      //todo: refactor
      color: _resolveStatusColor(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          compassEnabled: true,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          circles: _circles,
        ),
      ),
    ));
  }
}
