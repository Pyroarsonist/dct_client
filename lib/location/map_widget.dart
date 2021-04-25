import 'dart:async';

import 'package:dct_client/jobs/get_status_and_locations.job.dart';
import 'package:dct_client/jobs/send-geodata.job.dart';
import 'package:dct_client/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:wakelock/wakelock.dart';

import '../constants.dart';
import '../push_notifications.dart';
import 'dtos/get_locations.dto.dart';
import 'enums/crowd_status_enum.dart';

class MapWidget extends StatefulWidget {
  const MapWidget();

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  StreamSubscription<Position> _positionStreamSubscription;
  Position _position;
  CrowdStatus _status;

  final Set<Heatmap> _heatmaps = {};

  final Set<Circle> _circles = {};

  Color _resolveStatusColor() {
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
    Wakelock.disable();
    super.dispose();
  }

  static Set<Heatmap> _createHeatmapsFromLocations(
      List<LocationDto> locations) {
    return locations.asMap().entries.map((entry) {
      final l = entry.value;
      final i = entry.key;

      final heatmap = Heatmap(
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

      return heatmap;
    }).toSet();
  }

  Future<void> _sendNotification(CrowdStatus newStatus) async {
    try {
      if (_status != null && newStatus != _status) {
        await scheduleNotification('Crowd status changed!');
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _geodataListener(Position position) async {
    if (!mounted) return;
    if (position == null) return;

    sendGeoData();
    final dto = await getStatusAndLocations();
    if (dto == null) return;

    await _sendNotification(dto.status);

    final heatmaps = await compute(_createHeatmapsFromLocations, dto.locations);

    setState(() {
      _position = position;
      _status = dto.status;

      _heatmaps.clear();
      _heatmaps.addAll(heatmaps);

      _circles.clear();
      _circles.add(Circle(
          strokeColor: Colors.blue,
          center: LatLng(position.latitude, position.longitude),
          radius: dto.radius,
          circleId: CircleId('radius-circle')));
    });
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    _positionStreamSubscription = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            intervalDuration: sendGeodataDurationInverval)
        .listen(_geodataListener);
  }

  static List<WeightedLatLng> _createPoints(LatLng location) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    for (var i = -1; i <= 1; i++) {
      for (var j = -1; j <= 1; j++) {
        points.add(_createWeightedLatLng(
            location.latitude + i, location.longitude + j, 1));
      }
    }

    return points;
  }

  static WeightedLatLng _createWeightedLatLng(
      double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {
      return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
    }

    return Scaffold(
        body: Container(
      color: _resolveStatusColor(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_position.latitude, _position.longitude),
            zoom: defaultMapsZoom,
          ),
          myLocationEnabled: true,
          circles: _circles,
          heatmaps: _heatmaps,
        ),
      ),
    ));
  }
}
