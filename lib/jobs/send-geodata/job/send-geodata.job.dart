import 'dart:convert';

import 'package:dct_client/config.dart';
import 'package:dct_client/geolocation/geolocation.dart';
import 'package:dct_client/jobs/send-geodata/job/dtos/geodata.dto.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:dct_client/utils.dart';
import 'package:http/http.dart';

void sendGeoData() async {
  var token = await TokenService.getToken();
  if (token == null) return;

  var position = await determinePosition();
  var dto = new GeoData(position.longitude, position.latitude);

  var url = "${Config.getBackendHost()}/locations";
  final response = await post(Uri.parse(url), body: jsonEncode(dto), headers: {
    'content-type': 'application/json',
    'Authorization': "Bearer $token"
  });
  if (Utils.isStatusCodeOk(response.statusCode)) return;
  if (Utils.isUnauthorized(response.statusCode)) {
    //todo: route to home
    await TokenService.removeToken();
  }
  Utils.logHttpError(response);
}
