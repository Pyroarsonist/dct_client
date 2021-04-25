import 'dart:convert';
import 'dart:io';

import 'package:dct_client/health/dtos/update_health.dto.dart';
import 'package:http/http.dart';

import '../config.dart';
import 'token_service.dart';

class HealthService {
  static Future<Response> getHealth() async {
    final token = await TokenService.getToken();
    if (token == null) return null;

    final url = '${Config.getBackendHost()}/health';

    final response = await get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });


    return response;
  }

  static Future<Response> updateHealth(UpdateHealthDto dto) async {
    final token = await TokenService.getToken();
    if (token == null) return null;

    final url = '${Config.getBackendHost()}/health';

    final response =
        await post(Uri.parse(url), body: jsonEncode(dto), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    return response;
  }
}
