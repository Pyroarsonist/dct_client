import 'package:flutter/material.dart';

import 'constants.dart';
import 'custom_app_bar.dart';
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
        drawer: const Drawer(child: DrawerChildWidget()),
        appBar: CustomAppBar(mapHeader),
        body: const Center(child: MapWidget()));
  }
}
