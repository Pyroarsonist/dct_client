import 'dart:convert';
import 'dart:io';
import 'package:dct_client/auth/dtos/login.dto.dart';
import 'package:dct_client/auth/dtos/register.dto.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:http/http.dart';

import '../config.dart';
import '../routes.dart';
import 'navigation_service.dart';

class AuthService {
  static Future<Response> login(LoginDto body) async {
    final url = '${Config.getBackendHost()}/auth/login';
    final response = await post(Uri.parse(url),
        body: jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    return response;
  }

  static Future<Response> register(RegisterDto body) async {
    final url = '${Config.getBackendHost()}/auth/register';
    final response = await post(Uri.parse(url),
        body: jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    return response;
  }

  static Future<void> logout() async {
    await TokenService.removeToken();
    await NavigationService.nonReturningNavigateTo(initialRoute);
  }
}
