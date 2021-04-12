import 'dart:convert';

import 'package:dct_client/geolocation/dtos/get_locations.dto.dart';
import 'package:dct_client/geolocation/dtos/send_geodata.dto.dart';
import 'package:http/http.dart';

import '../config.dart';

class GeolocationService {
  static Future<Response> sendGeoData(SendGeoDataDto dto, String token) async {

    var url = "${Config.getBackendHost()}/locations";
    final response = await post(Uri.parse(url),
        body: jsonEncode(dto),
        headers: {
          'content-type': 'application/json',
          'Authorization': "Bearer $token"
        });

    return response;
  }

  static Future<Response> getStatusAndLocations(
      GetLocationsRequestDto dto, String token) async {
    var query = Uri(queryParameters: dto.toQuery()).query;
    var url = "${Config.getBackendHost()}/locations?$query";

    final response = await get(Uri.parse(url), headers: {
      'content-type': 'application/json',
      'Authorization': "Bearer $token"
    });

    return response;
  }
}
