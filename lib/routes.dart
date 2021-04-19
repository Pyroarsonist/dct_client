import 'package:flutter/material.dart';

import 'auth/auth_widget.dart';
import 'auth/login_widget.dart';
import 'auth/register_widget.dart';
import 'home_widget.dart';
import 'splash_screen.dart';

const initialRoute = '/';
const homeRoute = '/home';
const authRoute = '/auth';
const loginRoute = '/auth/login';
const registerRoute = '/auth/register';

Map<String, Widget Function(BuildContext)> routes = {
  initialRoute: (context) => SplashScreen(),
  homeRoute: (context) => HomeWidget(),
  authRoute: (context) => AuthWidget(),
  loginRoute: (context) => LoginWidget(),
  registerRoute: (context) => RegisterWidget(),
};
