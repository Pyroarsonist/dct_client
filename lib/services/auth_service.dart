import 'dart:convert';
import 'package:dct_client/auth/dtos/login.dto.dart';
import 'package:dct_client/auth/dtos/register.dto.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../config.dart';
import '../main.dart';

class AuthService {
  static Future<Response> login(LoginDto body) async {
    var url = "${Config.getBackendHost()}/auth/login";
    final response = await post(Uri.parse(url),
        body: jsonEncode(body), headers: {'content-type': 'application/json'});
    return response;
  }

  static Future<Response> register(RegisterDto body) async {
    var url = "${Config.getBackendHost()}/auth/register";
    final response = await post(Uri.parse(url),
        body: jsonEncode(body), headers: {'content-type': 'application/json'});
    return response;
  }

  static Future<void> logout(BuildContext context) async {
    await TokenService.removeToken();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyApp(false);
    }));
  }
}
