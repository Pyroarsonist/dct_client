import 'package:dct_client/services/auth_service.dart';
import 'package:dct_client/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'constants.dart';
import 'routes.dart';

class DrawerChildWidget extends StatelessWidget {
  final String _header;

  const DrawerChildWidget([this._header = appTitle]);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 100,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              _header,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.map_rounded),
          title: const Text('Map'),
          onTap: () {
            NavigationService.nonReturningNavigateTo(homeRoute);
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Profile'),
          onTap: () {
            NavigationService.nonReturningNavigateTo(profileRoute);
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_hospital ),
          title: const Text('Health'),
          onTap: () {
            NavigationService.nonReturningNavigateTo(healthRoute);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () => AuthService.logout(),
        )
      ],
    );
  }
}
