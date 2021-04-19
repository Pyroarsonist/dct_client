import 'dart:convert';
import 'dart:io';

import 'package:dct_client/profile/dtos/update_profile.dto.dart';
import 'package:http/http.dart';

import '../config.dart';
import 'token_service.dart';

class ProfileService {
  static Future<Response> getProfile() async {
    final token = await TokenService.getToken();
    if (token == null) return null;

    final url = '${Config.getBackendHost()}/profile';

    final response = await get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });


    return response;
  }

  static Future<Response> updateProfile(UpdateProfileDto dto) async {
    final token = await TokenService.getToken();
    if (token == null) return null;

    final url = '${Config.getBackendHost()}/profile';

    final response =
        await post(Uri.parse(url), body: jsonEncode(dto), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    return response;
  }
}
