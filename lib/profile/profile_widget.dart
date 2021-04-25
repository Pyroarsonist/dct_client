import 'dart:convert';

import 'package:dct_client/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../custom_app_bar.dart';
import '../drawer_child_widget.dart';
import '../services/profile_service.dart';
import '../utils.dart';
import 'dtos/get_profile.dto.dart';
import 'profile_edit_widget.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileWidget> {
  var _profileFuture = _getProfile();

  static Future<GetProfileDto> _getProfile() async {
    final resp = await ProfileService.getProfile();
    if (!Utils.isStatusCodeOk(resp.statusCode)) {
      if (Utils.isUnauthorized(resp.statusCode)) {
        AuthService.logout();
      }
      Utils.logHttpError(resp);
      throw Exception('Failed loading profile');
    }

    final profile = GetProfileDto.fromJson(jsonDecode(resp.body));
    return profile;
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _profileFuture = _getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerChildWidget()),
      appBar: CustomAppBar(profileHeader),
      body: Center(
        child: FutureBuilder<GetProfileDto>(
          future: _profileFuture,
          builder:
              (BuildContext context, AsyncSnapshot<GetProfileDto> snapshot) {
            if (snapshot.hasData) {
              final profile = snapshot.data;

              return RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () => _refreshProfile(),
                  child: ProfileEditWidget(profile: profile));
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
