import 'dart:convert';
import 'dart:io';

import 'package:dct_client/location/dtos/get_locations.dto.dart';
import 'package:dct_client/location/dtos/send_geodata.dto.dart';
import 'package:http/http.dart';

import '../config.dart';

class GeolocationService {
  static Future<Response> sendGeoData(SendGeoDataDto dto, String token) async {

    final url = '${Config.getBackendHost()}/locations';
    final response = await post(Uri.parse(url),
        body: jsonEncode(dto),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        });

    return response;
  }

  static Future<Response> getStatusAndLocations(
      GetLocationsRequestDto dto, String token) async {
    final query = Uri(queryParameters: dto.toQuery()).query;
    final url = '${Config.getBackendHost()}/locations?$query';

    final response = await get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    return response;
  }
}
