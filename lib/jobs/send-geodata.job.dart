import 'package:dct_client/geolocation/geolocation.dart';
import 'package:dct_client/geolocation/dtos/send_geodata.dto.dart';
import 'package:dct_client/services/geolocation_service.dart';
import 'package:dct_client/services/navigation_service.dart';
import 'package:dct_client/services/token_service.dart';
import 'package:dct_client/utils.dart';

import '../routes.dart';

Future<void> sendGeoData() async {
  final token = await TokenService.getToken();
  if (token == null) return;

  final position = await determinePosition();
  final dto = SendGeoDataDto(position.latitude, position.longitude);

  final response = await GeolocationService.sendGeoData(dto, token);
  if (Utils.isStatusCodeOk(response.statusCode)) return;
  if (Utils.isUnauthorized(response.statusCode)) {
    await TokenService.removeToken();
    await NavigationService.nonReturningNavigateTo(initialRoute);
  }
  Utils.logHttpError(response);
}
