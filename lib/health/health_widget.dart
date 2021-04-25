import 'dart:convert';

import 'package:dct_client/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../custom_app_bar.dart';
import '../drawer_child_widget.dart';
import '../services/health_service.dart';
import '../utils.dart';
import 'dtos/get_health.dto.dart';
import 'health_edit_widget.dart';

class HealthWidget extends StatefulWidget {
  @override
  _HealthState createState() => _HealthState();
}

class _HealthState extends State<HealthWidget> {
  var _healthFuture = _getHealth();

  static Future<GetHealthDto> _getHealth() async {
    final resp = await HealthService.getHealth();
    if (!Utils.isStatusCodeOk(resp.statusCode)) {
      if (Utils.isUnauthorized(resp.statusCode)) {
        AuthService.logout();
      }
      Utils.logHttpError(resp);
      throw Exception('Failed loading health');
    }

    final health = GetHealthDto.fromJson(jsonDecode(resp.body));
    return health;
  }

  Future<void> _refreshhealth() async {
    setState(() {
      _healthFuture = _getHealth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerChildWidget()),
      appBar: CustomAppBar(healthHeader),
      body: Center(
        child: FutureBuilder<GetHealthDto>(
          future: _healthFuture,
          builder:
              (BuildContext context, AsyncSnapshot<GetHealthDto> snapshot) {
            if (snapshot.hasData) {
              final health = snapshot.data;

              return RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () => _refreshhealth(),
                  child: HealthEditWidget(health: health));
            }

            if (snapshot.hasError) {
              return const Text('Error', style: TextStyle(color: Colors.red));
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
