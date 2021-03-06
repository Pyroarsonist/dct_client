import 'dart:io';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../utils.dart';

class TokenService {
  static const _tokenKey = 'auth-token';
  static String _token;

  static Future<void> saveToken(String t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, t);
    _token = t;
  }

  static Future<String> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    final tokenFromPref = prefs.getString(_tokenKey);
    _token = tokenFromPref;
    return _token;
  }

  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;
    final url = '${Config.getBackendHost()}/auth';
    final response = await get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    if (Utils.isStatusCodeOk(response.statusCode)) {
      return true;
    }
    return false;
  }

  static Future<void> removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
