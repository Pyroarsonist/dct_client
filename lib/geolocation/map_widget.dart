import 'dart:async';

import 'package:dct_client/jobs/get_status_and_locations.job.dart';
import 'package:dct_client/jobs/send-geodata.job.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

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
  Set<Heatmap> _heatmaps = {};

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
            intervalDuration: sendGeodataDurationInverval)
        .listen((Position position) async {
      if (position == null) return;

      sendGeoData();
      final dto = await getStatusAndLocations();
      setState(() {
        _position = position;
        _status = dto.status;

        // _circles = dto.locations.asMap().entries.map((entry) {
        //   var l = entry.value;
        //   var i = entry.key;
        //
        //   var circle = Circle(
        //     circleId: CircleId("circle_id:$i"),
        //     strokeColor: Colors.red,
        //     fillColor: Colors.orange,
        //     strokeWidth: 2,
        //     center: LatLng(l.latitude, l.longitude),
        //     radius: 15,
        //   );
        //
        //   return circle;
        // }).toSet();

        _heatmaps = dto.locations.asMap().entries.map((entry) {
          final l = entry.value;
          final i = entry.key;

          // var circle = Heatmap(
          //     heatmapId: HeatmapId("heatmap_id:$i"),
          //     radius: 20,
          //     points: _createPoints(LatLng(l.latitude, l.longitude)),
          //     gradient: HeatmapGradient(
          //         colors: <Color>[Colors.green, Colors.red],
          //         startPoints: <double>[0.2, 0.8]));

          final circle = Heatmap(
              heatmapId: HeatmapId('heatmap_id:$i'),
              radius: 30,
              points: _createPoints(LatLng(l.latitude, l.longitude)),
              gradient: HeatmapGradient(colors: <Color>[
                Colors.lightGreenAccent.shade400,
                Colors.redAccent.shade700
              ], startPoints: const <double>[
                0.2,
                0.9
              ]));

          return circle;
        }).toSet();
      });

      // //todo: refactor
      //   final GoogleMapController controller = await _controller.future;
      //
      //   var cameraPosition = CameraPosition(
      //     target: LatLng(
      //       position.latitude,
      //       position.longitude,
      //     ),
      //     zoom: DEFAULT_MAPS_ZOOM,
      //   );
      //
      //   controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  List<WeightedLatLng> _createPoints(LatLng location) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    for (var i = -1; i <= 1; i++) {
      for (var j = -1; j <= 1; j++) {
        points.add(_createWeightedLatLng(
            location.latitude + i, location.longitude + j, 1));
      }
    }

    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  @override
  Widget build(BuildContext context) {
    _kGooglePlex = CameraPosition(
      target:
          //todo: fix null
          LatLng(_position?.latitude ?? 0, _position?.longitude ?? 0),
      zoom: defaultMapsZoom,
    );

    if (_position == null) {
      return const CircularProgressIndicator(
        backgroundColor: Colors.blue,
      );
    }

    return Scaffold(
        body: Container(
      //todo: refactor
      color: _resolveStatusColor(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          circles: _circles,
          heatmaps: _heatmaps,
        ),
      ),
    ));
  }
}
