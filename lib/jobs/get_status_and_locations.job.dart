import 'dart:convert';

import 'package:dct_client/location/dtos/get_locations.dto.dart';
import 'package:dct_client/location/location.dart';
import 'package:dct_client/services/location_service.dart';
import 'package:dct_client/services/navigation_service.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:dct_client/utils.dart';
import 'package:flutter/foundation.dart';

import '../routes.dart';

GetLocationsResponseDto _decodeResponse(String str) {
  return GetLocationsResponseDto.fromJson(jsonDecode(str));
}

Future<GetLocationsResponseDto> getStatusAndLocations() async {
  final token = await TokenService.getToken();
  if (token == null) return null;

  final position = await determinePosition();
  final dto = GetLocationsRequestDto(position.latitude, position.longitude);

  final response = await GeolocationService.getStatusAndLocations(dto, token);
  if (Utils.isStatusCodeOk(response.statusCode)) {
    return compute(_decodeResponse, response.body);
  }
  if (Utils.isUnauthorized(response.statusCode)) {
    await TokenService.removeToken();

    await NavigationService.nonReturningNavigateTo(initialRoute);
  }
  Utils.logHttpError(response);
  return null;
}
