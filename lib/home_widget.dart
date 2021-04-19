import 'package:flutter/material.dart';

import 'constants.dart';
import 'drawer_child_widget.dart';
import 'geolocation/map_widget.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(child: DrawerChildWidget(mapHeader)),
        appBar: AppBar(
          title: const Text(appTitle),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: MapWidget()));
  }
}
