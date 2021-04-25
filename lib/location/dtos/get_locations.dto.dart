import 'package:dct_client/location/enums/crowd_status_enum.dart';

class GetLocationsRequestDto {
  double latitude;
  double longitude;

  GetLocationsRequestDto(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, String> toQuery() {
    return {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }
}

class LocationDto {
  double latitude;
  double longitude;

  LocationDto(this.latitude, this.longitude);

  factory LocationDto.fromJson(dynamic dto) {
    return LocationDto(
      (dto['latitude'] as num).toDouble(),
      (dto['longitude'] as num).toDouble(),
    );
  }
}

class GetLocationsResponseDto {
  CrowdStatus status;
  List<LocationDto> locations;
  double radius;

  GetLocationsResponseDto(this.status, this.locations, this.radius);

  static CrowdStatus resolveCrowdStatus(String status) {
    if (status == 'good') return CrowdStatus.good;
    if (status == 'ok') return CrowdStatus.ok;
    return CrowdStatus.bad;
  }

  factory GetLocationsResponseDto.fromJson(dynamic dto) {
    final locations = dto['locations']
        .map<LocationDto>((l) => LocationDto.fromJson(l))
        .toList();
    return GetLocationsResponseDto(
      resolveCrowdStatus(dto['status'] as String),
      locations as List<LocationDto>,
      (dto['radius'] as num).toDouble(),
    );
  }
}
