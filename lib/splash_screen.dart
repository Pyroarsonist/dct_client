import 'dart:async';
import 'package:flutter/material.dart';

import 'routes.dart';
import 'services/token_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            //todo: change logo
              image: AssetImage('assets/images/splash_screen_logo.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  void navigateUser()  {
    final tokenIsValidFuture =  TokenService.isTokenValid();
    Timer(const Duration(seconds: 1),  () async {
      final tokenIsValid = await tokenIsValidFuture;
      Navigator.pushReplacementNamed(context, tokenIsValid ? homeRoute : authRoute);
    });
  }

}
