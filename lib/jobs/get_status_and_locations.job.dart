import 'dart:convert';

import 'package:dct_client/geolocation/dtos/get_locations.dto.dart';
import 'package:dct_client/geolocation/geolocation.dart';
import 'package:dct_client/services/geolocation_service.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:dct_client/utils.dart';

Future<GetLocationsResponseDto> getStatusAndLocations() async {
  final token = await TokenService.getToken();
  if (token == null) return null;

  final position = await determinePosition();
  final dto =  GetLocationsRequestDto(position.latitude, position.longitude);


  final response = await GeolocationService.getStatusAndLocations(dto, token);
  if (Utils.isStatusCodeOk(response.statusCode)) {
    final dto = GetLocationsResponseDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return dto;
  }
  if (Utils.isUnauthorized(response.statusCode)) {
    //todo: route to home
    await TokenService.removeToken();
  }
  Utils.logHttpError(response);
  return null;
}
